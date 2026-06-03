variable "CHANGE_SOURCE" {
  default = "false"
}

variable "REGISTRY" {
  default = "harbor.cluster.internal"
}

variable "JETBRAINS_DOWNLOAD_URL" {
  default = "http://mirrors.cluster.internal/jetbrains/backends/RR/RustRover-2026.1.2.tar.gz"
}

group default {
  targets = ["rust"]
}

target "rust" {
  context     = "."
  dockerfile  = "Dockerfile"
  matrix = {
    item = [
      {
        version = "1_96_0"
        upstream = "rust:1.96.0-trixie"
        tags = ["${REGISTRY}/coder-images/rust:1.96.0"]
      },
    ]
  }

  name = "rust-${item.version}"
  args = {
    UPSTREAM = item.upstream
    CHANGE_SOURCE = "${CHANGE_SOURCE}"
    JETBRAINS_DOWNLOAD_URL = "${JETBRAINS_DOWNLOAD_URL}"
  }
  tags = item.tags
}
