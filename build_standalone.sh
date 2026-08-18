#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
KRISTAL_I18N_EXAMPLE_MOD_DIR="${KRISTAL_I18N_EXAMPLE_MOD_DIR:-$SCRIPT_DIR}"
KRISTAL_I18N_EXAMPLE_MOD_DIR="$(CDPATH= cd -- "$KRISTAL_I18N_EXAMPLE_MOD_DIR" && pwd -P)"
KRISTAL_I18N_EXAMPLE_BUILD_ROOT="${KRISTAL_I18N_EXAMPLE_BUILD_ROOT:-$KRISTAL_I18N_EXAMPLE_MOD_DIR/.build/standalone}"
KRISTAL_I18N_EXAMPLE_OUTPUT_DIR="${KRISTAL_I18N_EXAMPLE_OUTPUT_DIR:-$KRISTAL_I18N_EXAMPLE_MOD_DIR/dist}"
KRISTAL_I18N_EXAMPLE_CACHE_DIR="${KRISTAL_I18N_EXAMPLE_CACHE_DIR:-$KRISTAL_I18N_EXAMPLE_MOD_DIR/.build/cache}"

KRISTAL_I18N_EXAMPLE_KRISTAL_REPO="${KRISTAL_I18N_EXAMPLE_KRISTAL_REPO:-https://github.com/KristalTeam/Kristal.git}"
KRISTAL_I18N_EXAMPLE_KRISTAL_REF="${KRISTAL_I18N_EXAMPLE_KRISTAL_REF:-f62afea63ccab02f468c24ac0d096bd8a2c9aa81}"
KRISTAL_I18N_EXAMPLE_KRISTAL_EXPECTED_VERSION="${KRISTAL_I18N_EXAMPLE_KRISTAL_EXPECTED_VERSION:-0.11.0-dev}"
KRISTAL_I18N_EXAMPLE_KRISTAL_DIR="${KRISTAL_I18N_EXAMPLE_KRISTAL_DIR:-${KRISTAL_ROOT:-$KRISTAL_I18N_EXAMPLE_MOD_DIR/.build/Kristal}}"

KRISTAL_I18N_EXAMPLE_MOD_ID="${KRISTAL_I18N_EXAMPLE_MOD_ID:-kristal-i18n-example}"
KRISTAL_I18N_EXAMPLE_PROJECT_TITLE="${KRISTAL_I18N_EXAMPLE_PROJECT_TITLE:-kristal-i18n-example}"
KRISTAL_I18N_EXAMPLE_OUTPUT_BASENAME="${KRISTAL_I18N_EXAMPLE_OUTPUT_BASENAME:-kristal-i18n-example}"
KRISTAL_I18N_EXAMPLE_EXE_BASENAME="${KRISTAL_I18N_EXAMPLE_EXE_BASENAME:-KRISTAL-I18N-EXAMPLE}"
KRISTAL_I18N_EXAMPLE_LOVE_VERSION="${KRISTAL_I18N_EXAMPLE_LOVE_VERSION:-11.5}"
KRISTAL_I18N_EXAMPLE_LOVE_ARCH="${KRISTAL_I18N_EXAMPLE_LOVE_ARCH:-win64}"
KRISTAL_I18N_EXAMPLE_LOVE_WINDOWS_ZIP_URL="${KRISTAL_I18N_EXAMPLE_LOVE_WINDOWS_ZIP_URL:-https://github.com/love2d/love/releases/download/${KRISTAL_I18N_EXAMPLE_LOVE_VERSION}/love-${KRISTAL_I18N_EXAMPLE_LOVE_VERSION}-${KRISTAL_I18N_EXAMPLE_LOVE_ARCH}.zip}"
KRISTAL_I18N_EXAMPLE_BUILD_VARIANTS="${KRISTAL_I18N_EXAMPLE_BUILD_VARIANTS:-release debug}"
KRISTAL_I18N_EXAMPLE_BUILD_WINDOWS_EXE="${KRISTAL_I18N_EXAMPLE_BUILD_WINDOWS_EXE:-1}"
KRISTAL_I18N_EXAMPLE_UPDATE_REPOS="${KRISTAL_I18N_EXAMPLE_UPDATE_REPOS:-0}"

log() {
    printf '[build] %s\n' "$*" >&2
}

need_cmd() {
    command -v "$1" >/dev/null 2>&1 || {
        printf 'Missing required command: %s\n' "$1" >&2
        exit 1
    }
}

ensure_kristal() {
    if [ -d "$KRISTAL_I18N_EXAMPLE_KRISTAL_DIR/.git" ]; then
        if [ "$KRISTAL_I18N_EXAMPLE_UPDATE_REPOS" = "1" ]; then
            git -C "$KRISTAL_I18N_EXAMPLE_KRISTAL_DIR" fetch --tags origin
        fi
    elif [ -e "$KRISTAL_I18N_EXAMPLE_KRISTAL_DIR" ]; then
        printf 'Kristal path exists but is not a Git checkout: %s\n' "$KRISTAL_I18N_EXAMPLE_KRISTAL_DIR" >&2
        exit 1
    else
        mkdir -p "$(dirname "$KRISTAL_I18N_EXAMPLE_KRISTAL_DIR")"
        git clone --filter=blob:none "$KRISTAL_I18N_EXAMPLE_KRISTAL_REPO" "$KRISTAL_I18N_EXAMPLE_KRISTAL_DIR"
    fi

    if ! git -C "$KRISTAL_I18N_EXAMPLE_KRISTAL_DIR" rev-parse --verify --quiet "${KRISTAL_I18N_EXAMPLE_KRISTAL_REF}^{commit}" >/dev/null; then
        case "$KRISTAL_I18N_EXAMPLE_KRISTAL_REF" in
            *[!0-9a-fA-F]*)
                git -C "$KRISTAL_I18N_EXAMPLE_KRISTAL_DIR" fetch --depth 1 origin "refs/tags/${KRISTAL_I18N_EXAMPLE_KRISTAL_REF}:refs/tags/${KRISTAL_I18N_EXAMPLE_KRISTAL_REF}"
                ;;
            *)
                git -C "$KRISTAL_I18N_EXAMPLE_KRISTAL_DIR" fetch --depth 1 origin "$KRISTAL_I18N_EXAMPLE_KRISTAL_REF"
                ;;
        esac
    fi

    version="$(git -C "$KRISTAL_I18N_EXAMPLE_KRISTAL_DIR" show "${KRISTAL_I18N_EXAMPLE_KRISTAL_REF}:VERSION" | tr -d '\r\n')"
    if [ "$version" != "$KRISTAL_I18N_EXAMPLE_KRISTAL_EXPECTED_VERSION" ]; then
        printf 'Kristal %s reports VERSION=%s, expected %s\n' "$KRISTAL_I18N_EXAMPLE_KRISTAL_REF" "$version" "$KRISTAL_I18N_EXAMPLE_KRISTAL_EXPECTED_VERSION" >&2
        exit 1
    fi
}

export_kristal() {
    stage_dir="$1"
    rm -rf "$stage_dir"
    mkdir -p "$stage_dir"
    git -C "$KRISTAL_I18N_EXAMPLE_KRISTAL_DIR" archive --format=tar "$KRISTAL_I18N_EXAMPLE_KRISTAL_REF" | tar -x -C "$stage_dir"
    rm -rf "$stage_dir/.github" "$stage_dir/mods" "$stage_dir/build" "$stage_dir/output"
}

copy_mod() {
    stage_mod="$1"
    mkdir -p "$stage_mod"
    rsync -a \
        --exclude='/.git/' \
        --exclude='.git' \
        --exclude='/.github/' \
        --exclude='/.build/' \
        --exclude='/dist/' \
        --exclude='/.claude/' \
        --exclude='/.emacs/' \
        --exclude='/.helix/' \
        --exclude='/.vscode/' \
        --exclude='/.worktrees/' \
        --exclude='/tests/' \
        --exclude='/docs/' \
        --exclude='/Makefile' \
        --exclude='/justfile' \
        --exclude='/build_standalone.sh' \
        --exclude='/build_standalone.py' \
        --exclude='/build_android.sh' \
        --exclude='__pycache__/' \
        --exclude='*.pyc' \
        --exclude='*.pyo' \
        --exclude='/release-please-config.json' \
        --exclude='/.release-please-manifest.json' \
        --exclude='/.gitmodules' \
        --exclude='/.gitignore' \
        --exclude='*.tiled-project' \
        --exclude='*.tiled-session' \
        "$KRISTAL_I18N_EXAMPLE_MOD_DIR/" "$stage_mod/"
}

zip_dir() {
    output="$1"
    source="$2"
    prefix="${3:-}"
    mkdir -p "$(dirname "$output")"
    rm -f "$output"
    if command -v zip >/dev/null 2>&1; then
        if [ -n "$prefix" ]; then
            (cd "$(dirname "$source")" && zip -9 -q -r "$output" "$(basename "$source")")
        else
            (cd "$source" && zip -9 -q -r "$output" .)
        fi
    else
        python3 "$KRISTAL_I18N_EXAMPLE_MOD_DIR/build_standalone.py" zip-dir "$output" "$source" "$prefix"
    fi
}

prepare_stage() {
    variant="$1"
    case "$variant" in
        release)
            release_mode=true
            mod_dev=false
            ;;
        debug)
            release_mode=false
            mod_dev=true
            ;;
        *)
            printf 'Unknown build variant: %s\n' "$variant" >&2
            exit 1
            ;;
    esac

    stage_dir="$KRISTAL_I18N_EXAMPLE_BUILD_ROOT/$variant/source"
    export_kristal "$stage_dir"
    stage_mod="$stage_dir/mods/$KRISTAL_I18N_EXAMPLE_MOD_ID"
    copy_mod "$stage_mod"
    if [ "$variant" = "release" ]; then
        identity="$KRISTAL_I18N_EXAMPLE_MOD_ID"
        title="$KRISTAL_I18N_EXAMPLE_PROJECT_TITLE"
    else
        identity="${KRISTAL_I18N_EXAMPLE_MOD_ID}_debug"
        title="${KRISTAL_I18N_EXAMPLE_PROJECT_TITLE} Debug"
    fi
    python3 "$KRISTAL_I18N_EXAMPLE_MOD_DIR/build_standalone.py" patch-lua-config \
        "$stage_dir" "$KRISTAL_I18N_EXAMPLE_MOD_ID" "$release_mode" \
        "$identity" "$title"
    if [ "${KRISTAL_I18N_EXAMPLE_ANDROID_TOUCH_SKIP_INTRO:-0}" = "1" ]; then
        python3 "$KRISTAL_I18N_EXAMPLE_MOD_DIR/build_standalone.py" patch-android-loading-touch \
            "$stage_dir/src/engine/loadstate.lua"
    fi
    python3 "$KRISTAL_I18N_EXAMPLE_MOD_DIR/build_standalone.py" patch-mod-manifest \
        "$stage_mod/mod.json" "$mod_dev"
    printf '%s\n' "$stage_dir"
}

ensure_love_windows() {
    [ "$KRISTAL_I18N_EXAMPLE_BUILD_WINDOWS_EXE" = "1" ] || return 0
    mkdir -p "$KRISTAL_I18N_EXAMPLE_CACHE_DIR"
    love_zip="$KRISTAL_I18N_EXAMPLE_CACHE_DIR/love-${KRISTAL_I18N_EXAMPLE_LOVE_VERSION}-${KRISTAL_I18N_EXAMPLE_LOVE_ARCH}.zip"
    love_dir="$KRISTAL_I18N_EXAMPLE_CACHE_DIR/love-${KRISTAL_I18N_EXAMPLE_LOVE_VERSION}-${KRISTAL_I18N_EXAMPLE_LOVE_ARCH}"
    if [ ! -f "$love_zip" ]; then
        curl --fail --location --output "$love_zip" "$KRISTAL_I18N_EXAMPLE_LOVE_WINDOWS_ZIP_URL"
    fi
    if [ ! -d "$love_dir" ]; then
        extract_dir="$KRISTAL_I18N_EXAMPLE_CACHE_DIR/love-${KRISTAL_I18N_EXAMPLE_LOVE_VERSION}-${KRISTAL_I18N_EXAMPLE_LOVE_ARCH}.extract"
        rm -rf "$extract_dir"
        mkdir -p "$extract_dir"
        unzip -q "$love_zip" -d "$extract_dir"
        extracted="$(find "$extract_dir" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
        [ -n "$extracted" ] || {
            printf 'Could not locate the extracted LÖVE directory\n' >&2
            exit 1
        }
        mv "$extracted" "$love_dir"
        rm -rf "$extract_dir"
    fi
    test -f "$love_dir/love.exe"
}

build_variant() {
    variant="$1"
    stage_dir="$(prepare_stage "$variant")"
    love_file="$KRISTAL_I18N_EXAMPLE_OUTPUT_DIR/${KRISTAL_I18N_EXAMPLE_OUTPUT_BASENAME}-${variant}.love"
    zip_dir "$love_file" "$stage_dir"

    if [ "$KRISTAL_I18N_EXAMPLE_BUILD_WINDOWS_EXE" = "1" ]; then
        love_dir="$KRISTAL_I18N_EXAMPLE_CACHE_DIR/love-${KRISTAL_I18N_EXAMPLE_LOVE_VERSION}-${KRISTAL_I18N_EXAMPLE_LOVE_ARCH}"
        package_name="${KRISTAL_I18N_EXAMPLE_OUTPUT_BASENAME}-${variant}-${KRISTAL_I18N_EXAMPLE_LOVE_ARCH}"
        package_dir="$KRISTAL_I18N_EXAMPLE_OUTPUT_DIR/$package_name"
        exe_name="${KRISTAL_I18N_EXAMPLE_EXE_BASENAME}-${variant}.exe"
        rm -rf "$package_dir"
        mkdir -p "$package_dir"
        cat "$love_dir/love.exe" "$love_file" > "$package_dir/$exe_name"
        cp "$love_dir"/*.dll "$package_dir/"
        test ! -f "$love_dir/license.txt" || cp "$love_dir/license.txt" "$package_dir/"
        zip_dir "$KRISTAL_I18N_EXAMPLE_OUTPUT_DIR/${package_name}.zip" "$package_dir" "$package_name"
    fi
}

need_cmd git
need_cmd python3
need_cmd rsync
need_cmd tar
need_cmd unzip
need_cmd curl
need_cmd zip
ensure_kristal
mkdir -p "$KRISTAL_I18N_EXAMPLE_OUTPUT_DIR"
ensure_love_windows
for variant in $KRISTAL_I18N_EXAMPLE_BUILD_VARIANTS; do
    build_variant "$variant"
done
