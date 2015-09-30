name   = builder
docker = docker run --volume=$(shell pwd):/input:rw --rm $(name)

PERCENT    := %
dimensions := "2000x1500"

build: out/slides.pdf

out/slides.pdf: tmp/png/.complete
	convert \
		-page $(dimensions) \
		$(dir $<)/*.png \
		-format pdf \
		$@

tmp/png/.complete: tmp/image.png
	mkdir -p $(dir $@)
	convert \
		-crop "1x80@" \
		-resize $(dimensions) \
		$< \
		$(dir $@)$(PERCENT)03d.png
	touch $@

tmp/image.png: src/slides.svg
	inkscape \
		--file=$(shell pwd)/$< \
		--export-png=$(shell pwd)/$@ \
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
