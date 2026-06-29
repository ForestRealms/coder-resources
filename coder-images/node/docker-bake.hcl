variable "CHANGE_SOURCE" {
  default = "false"
}

variable "REGISTRY" {
  default = "harbor.cluster.internal"
}

variable "JETBRAINS_DOWNLOAD_URL" {
  default = "http://mirrors.cluster.internal/jetbrains/backends/WS/WebStorm-2026.1.3.tar.gz"
}

variable "FILE_BROWSER_DOWNLOAD_URL" {
  default = "https://git.yylx.win/github.com/filebrowser/filebrowser/releases/download/v2.63.17/linux-amd64-filebrowser.tar.gz"
}

group default {
  targets = ["node"]
}

target "node" {
  context = "."
  matrix = {
    item = [
      {
        version   = "26"
        upstream  = "node:26-trixie"
        tags      = ["${REGISTRY}/coder-images/node:26", "${REGISTRY}/coder-images/node:latest"]
      },
      {
        version   = "24"
        upstream  = "node:24-trixie"
        tags      = ["${REGISTRY}/coder-images/node:24"]
      },
      {
        version   = "22"
        upstream  = "node:22-trixie"
        tags      = ["${REGISTRY}/coder-images/node:22"]
      },
    ]
  }

  name = "node-${item.version}"
  dockerfile = "Dockerfile"
  args = {
    UPSTREAM      = item.upstream
    CHANGE_SOURCE = "${CHANGE_SOURCE}"
    JETBRAINS_DOWNLOAD_URL = "${JETBRAINS_DOWNLOAD_URL}"
    FILE_BROWSER_DOWNLOAD_URL = "${FILE_BROWSER_DOWNLOAD_URL}"
  }
  tags = item.tags
}
