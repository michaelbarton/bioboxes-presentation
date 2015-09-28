name   = builder
docker = docker run --volume=$(shell pwd):/input:rw --rm $(name)

PERCENT    := %
dimensions := "2000x1500"

build: tmp/png/.complete

tmp/png/.complete: tmp/image.png
	mkdir -p $(dir $@)
	$(docker) convert \
		-crop "1x50@" \
		-resize $(dimensions) \
		/input/$< \
		/input/$(dir $@)$(PERCENT)03d.png
	touch $@

tmp/image.png: src/slides.svg .image
	$(docker) inkscape \
		--file=/input/$< \
		--export-png=/input/$@ \
		--export-dpi=100 \
		--export-area-page

########################################
#
# Bootstrap the project resources
#
########################################

bootstrap: .image
	mkdir -p tmp out

.image: Dockerfile
	docker build -t $(name) .
	touch $@

clean:
	rm -rf tmp/* out/* .image
