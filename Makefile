KRISTAL ?=

.PHONY: test test-static test-tiled test-kristal build-android

test: test-static test-tiled

test-static:
	jq empty lang/en.json lang/zh_hans.json libraries/kristal-i18n/lib.json libraries/kristal-i18n/lang/en.json libraries/kristal-i18n/lang/zh_hans.json
	jq -e '([keys[] | select(test("[^A-Za-z0-9_./-]"))] | length) == 0' libraries/kristal-i18n/lang/en.json >/dev/null
	jq -e '([keys[] | select(test("[^A-Za-z0-9_./-]"))] | length) == 0' libraries/kristal-i18n/lang/zh_hans.json >/dev/null
	find scripts libraries -type f -name '*.lua' -exec luajit -b {} /dev/null \;

test-tiled:
	@for map_file in scripts/world/maps/*.tmx; do \
		count=$$(xmllint --xpath 'count(//object[properties/property[starts-with(@name, "id")]][properties/property[starts-with(@name, "text")]])' "$$map_file"); \
		if [ "$$count" != "0" ]; then \
			printf 'Tiled object in %s has both id* and text* properties.\n' "$$map_file"; \
			exit 1; \
		fi; \
	done

test-kristal:
	KRISTAL="$(KRISTAL)" sh .github/scripts/run-kristal-smoke.sh

build-android:
	./build_android.sh
