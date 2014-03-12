REPORTER = nyan

test:
	./node_modules/.bin/mocha --compilers coffee:coffee-script/register --reporter $(REPORTER)

.PHONY: test
