.PHONY: all env push

SPACK_INSTALL_FLAGS=--no-check-signature

all: push

env: spack/env

include env.mk

env.mk: /build/spack.lock
	spack env depfile -o $@ --make-prefix spack

spack/push/%: spack/install/%
	spack buildcache push --unsigned --only=package ci-mirror /$(HASH) # $(SPEC)

push: $(addprefix spack/push/,$(spack/SPACK_PACKAGE_IDS))
	spack buildcache update-index $(SPACK_CACHE)


