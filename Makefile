
build: components index.js stretch-div.css
	coffee --compile --bare index.coffee
	jade index.jade
	@component build --dev

components: component.json
	@component install --dev

clean:
	rm -fr build components template.js

.PHONY: clean
