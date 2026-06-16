variable "CHANGE_SOURCE" {
  default = "false"
}

variable "REGISTRY" {
  default = "harbor.cluster.internal"
}

variable "JETBRAINS_DOWNLOAD_URL" {
  default = "http://mirrors.cluster.internal/jetbrains/backends/PY/pycharm-2026.1.2.tar.gz"
}

group default {
  targets = ["python"]
}

target "python" {
  context = "."
  matrix = {
    item = [
      {
        version   = "314"
        upstream  = "python:3.14.6-trixie"
        tags      = ["${REGISTRY}/coder-images/python:3.14", "${REGISTRY}/coder-images/python:3.14.6", "${REGISTRY}/coder-images/python:latest"]
      },
      {
        version   = "313"
        upstream  = "python:3.13.14-trixie"
        tags      = ["${REGISTRY}/coder-images/python:3.13", "${REGISTRY}/coder-images/python:3.13.14"]
      },
      {
        version   = "312"
        upstream  = "python:3.12.13-trixie"
        tags      = ["${REGISTRY}/coder-images/python:3.12", "${REGISTRY}/coder-images/python:3.12.13"]
      },
      {
        version   = "311"
        upstream  = "python:3.11.15-trixie"
        tags      = ["${REGISTRY}/coder-images/python:3.11", "${REGISTRY}/coder-images/python:3.11.15"]
      },
      {
        version   = "310"
        upstream  = "python:3.10.20-trixie"
        tags      = ["${REGISTRY}/coder-images/python:3.10", "${REGISTRY}/coder-images/python:3.10.20"]
      },
    ]
  }

  name = "python-${item.version}"
  dockerfile = "Dockerfile"
  args = {
    UPSTREAM      = item.upstream
    CHANGE_SOURCE = "${CHANGE_SOURCE}"
    JETBRAINS_DOWNLOAD_URL = "${JETBRAINS_DOWNLOAD_URL}"
  }
  tags = item.tags
}
