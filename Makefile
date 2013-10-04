
build: components index.js stretch_div.css
	coffee --compile --bare index.coffee
	jade index.jade
	@component build --dev

components: component.json
	@component install --dev

install: components index.js
	 component build --standalone stretch_div --out . --name stretch_div

clean:
	rm -fr build components template.js

.PHONY: clean
