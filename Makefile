$(shell mkdir -p tmp/png out)

name   = builder
docker = docker \
	   run \
	   --volume=$(shell pwd):/mnt:rw \
	   --rm \
	   $(name)

PERCENT    := %
dimensions := "2000x1500"

build: $(patsubst data/%.txt,out/%.pdf,$(shell find data -name '*.txt'))


out/%.pdf: data/%.txt tmp/slides.pdf
	pdfjam $(lastword $^) $(cut -f 1 $< | paste -sd "," -) -o $<

tmp/slides.pdf: tmp/png/.complete
	convert \
		-page $(dimensions) \
		/mnt/*.png \
		-format pdf \
		$@

tmp/png/.complete: tmp/image.png
	convert \
		-crop "1x80@" \
		-resize $(dimensions) \
		$< \
		/mnt/$(PERCENT)03d.png
	touch $@

tmp/image.png: src/slides.svg
	$(docker)
	inkscape \
		--file=/mnt/$< \
		--export-png=/mnt/$@ \
		--export-dpi=100 \
		--export-area-page

########################################
#
# Bootstrap the project resources
#
########################################

bootstrap: .image

.image: Dockerfile
	docker build -t $(name) .
	touch $@

clean:
	rm -rf tmp/* out/* .image
