variable "CHANGE_SOURCE" {
  default = "false"
}

variable "REGISTRY" {
  default = "harbor.cluster.internal"
}

variable "JETBRAINS_DOWNLOAD_URL" {
  default = "http://mirrors.cluster.internal/jetbrains/backends/RR/RustRover-2026.1.4.tar.gz"
}

variable "FILE_BROWSER_DOWNLOAD_URL" {
  default = "https://git.yylx.win/github.com/filebrowser/filebrowser/releases/download/v2.63.18/linux-amd64-filebrowser.tar.gz"
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
    FILE_BROWSER_DOWNLOAD_URL = "${FILE_BROWSER_DOWNLOAD_URL}"
  }
  tags = item.tags
}
