REPORTER = min
WATCH = --watch

test:
	./node_modules/.bin/mocha --compilers coffee:coffee-script/register --reporter $(REPORTER) $(WATCH)

.PHONY: test
