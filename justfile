default: test

# Run the example mod with a local Kristal checkout.
run *args:
    #!/usr/bin/env bash
    set -euo pipefail

    mod_root=$(CDPATH= cd -- "{{ justfile_directory() }}" && pwd -P)
    engine_root="${KRISTAL_ROOT:-}"
    if [ -z "$engine_root" ]; then
        user_home="${HOME:-}"
        for candidate in \
            "$mod_root/../Kristal" \
            "$mod_root/../kristal" \
            "$mod_root/../../Kristal" \
            "$mod_root/../../kristal" \
            "$user_home/Projects/LuaProjects/Kristal" \
            "$user_home/Projects/Kristal" \
            "$user_home/Kristal"
        do
            if [ -f "$candidate/main.lua" ]; then
                engine_root=$(CDPATH= cd -- "$candidate" && pwd -P)
                break
            fi
        done
    fi

    if [ -z "$engine_root" ] || [ ! -f "$engine_root/main.lua" ]; then
        printf '%s\n' 'Kristal was not found; set KRISTAL_ROOT=/path/to/Kristal.' >&2
        exit 1
    fi

    # Translate short flags (-l / -nl) before launching: Kristal only parses
    # "--" flags, so the i18n library reads them as --lang / --name-lang.
    normalized=()
    pending=
    for arg in {{ args }}; do
        case "$arg" in
            -l) pending="--lang" ;;
            -nl) pending="--name-lang" ;;
            *)
                if [ -n "$pending" ]; then
                    normalized+=("$pending" "$arg")
                    pending=
                else
                    normalized+=("$arg")
                fi
                ;;
        esac
    done
    if [ -n "$pending" ]; then
        printf '%s\n' "Missing value for $pending" >&2
        exit 1
    fi

    cd "$engine_root"
    exec love "$engine_root" --mod kristal-i18n-example --auto-mod-start "${normalized[@]}"

test:
    @make test

test-kristal:
    @make test-kristal

build:
    @./build_standalone.sh

build-android:
    @./build_android.sh

build-mod:
    @./.github/scripts/build_mod.sh

clean-build:
    rm -rf .build dist
