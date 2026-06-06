variable "CHANGE_SOURCE" {
  default = "false"
}

variable "REGISTRY" {
  default = "harbor.cluster.internal"
}

variable "JETBRAINS_DOWNLOAD_URL" {
  default = "http://mirrors.cluster.internal/jetbrains/backends/IU/idea-2026.1.3.tar.gz"
}

group default {
  targets = ["jdk"]
}

target "jdk" {
  context     = "."
  dockerfile  = "Dockerfile"
  matrix = {
    item = [
      {
        version = "8"
        upstream = "ibm-semeru-runtimes:open-8-jdk"
        tags = ["${REGISTRY}/coder-images/ibm-semeru-runtimes:8"]
      },
      {
        version = "11"
        upstream = "ibm-semeru-runtimes:open-11-jdk"
        tags = ["${REGISTRY}/coder-images/ibm-semeru-runtimes:11"]
      },
      {
        version = "17"
        upstream = "ibm-semeru-runtimes:open-17-jdk"
        tags = ["${REGISTRY}/coder-images/ibm-semeru-runtimes:17"]
      },
      {
        version = "21"
        upstream = "ibm-semeru-runtimes:open-21-jdk"
        tags = ["${REGISTRY}/coder-images/ibm-semeru-runtimes:21"]
      },
      {
        version = "25"
        upstream = "ibm-semeru-runtimes:open-25-jdk"
        tags = [
          "${REGISTRY}/coder-images/ibm-semeru-runtimes:25",
          "${REGISTRY}/coder-images/ibm-semeru-runtimes:latest"
        ]
      },
      {
        version = "26"
        upstream = "ibm-semeru-runtimes:open-26-jdk"
        tags = ["${REGISTRY}/coder-images/ibm-semeru-runtimes:26"]
      }
    ]
  }

  name = "jdk-${item.version}"
  args = {
    UPSTREAM = item.upstream
    CHANGE_SOURCE = "${CHANGE_SOURCE}"
    JETBRAINS_DOWNLOAD_URL = "${JETBRAINS_DOWNLOAD_URL}"
  }
  tags = item.tags
}
