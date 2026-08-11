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

    cd "$engine_root"
    exec love "$engine_root" --mod kristal-i18n-example --auto-mod-start {{ args }}

test: test-static test-tiled

test-static:
    @jq empty lang/en.json lang/zh_hans.json libraries/kristal-i18n/lib.json libraries/kristal-i18n/lang/en.json libraries/kristal-i18n/lang/zh_hans.json
    @jq -e '([keys[] | select(test("[^A-Za-z0-9_./-]"))] | length) == 0' libraries/kristal-i18n/lang/en.json >/dev/null
    @jq -e '([keys[] | select(test("[^A-Za-z0-9_./-]"))] | length) == 0' libraries/kristal-i18n/lang/zh_hans.json >/dev/null
    @find scripts libraries -type f -name '*.lua' -print0 | xargs -0 -n1 luac -p

test-tiled:
    #!/usr/bin/env bash
    set -euo pipefail
    for map_file in scripts/world/maps/*.tmx; do
        paired_count=$(xmllint --xpath 'count(//object[properties/property[starts-with(@name, "id")]][properties/property[starts-with(@name, "text")]])' "$map_file")
        if [ "$paired_count" -ne 0 ]; then
            printf 'Tiled object in %s has both id* and text* properties.\n' "$map_file" >&2
            exit 1
        fi
    done

# Run the Kristal smoke test explicitly because it starts the game process.
test-kristal:
    #!/usr/bin/env bash
    set -euo pipefail
    set +e
    timeout 10s just run
    status=$?
    set -e
    if [ "$status" -ne 0 ] && [ "$status" -ne 124 ]; then
        exit "$status"
    fi
