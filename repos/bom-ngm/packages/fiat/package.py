class Fiat(CMakePackage):
    git = "https://github.com/ecmwf-ifs/fiat"
    url = "https://github.com/ecmwf-ifs/fiat/archive/refs/tags/1.1.2.tar.gz"

    version(
        "1.1.2",
        sha256="92a0cdbc96831b15ab8a36262a9de972c6606a7dd9245cccebd2448d6846252d",
    )

    depends_on("ecbuild", type="build")
    depends_on("fckit")
    depends_on("eckit")
