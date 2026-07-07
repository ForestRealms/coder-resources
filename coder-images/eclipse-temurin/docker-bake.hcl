variable "CHANGE_SOURCE" {
  default = "false"
}

variable "REGISTRY" {
  default = "harbor.cluster.internal"
}

variable "JETBRAINS_DOWNLOAD_URL" {
  default = "http://mirrors.cluster.internal/jetbrains/backends/IU/idea-2026.1.4.tar.gz"
}

variable "FILE_BROWSER_DOWNLOAD_URL" {
  default = "https://github.com/filebrowser/filebrowser/releases/download/v2.63.18/linux-amd64-filebrowser.tar.gz"
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
        upstream = "eclipse-temurin:8-jdk-resolute"
        tags = ["${REGISTRY}/coder-images/eclipse-temurin:8"]
      },
      {
        version = "11"
        upstream = "eclipse-temurin:11-jdk-resolute"
        tags = ["${REGISTRY}/coder-images/eclipse-temurin:11"]
      },
      {
        version = "17"
        upstream = "eclipse-temurin:17-jdk-resolute"
        tags = ["${REGISTRY}/coder-images/eclipse-temurin:17"]
      },
      {
        version = "21"
        upstream = "eclipse-temurin:21-jdk-resolute"
        tags = ["${REGISTRY}/coder-images/eclipse-temurin:21"]
      },
      {
        version = "25"
        upstream = "eclipse-temurin:25-jdk-resolute"
        tags = [
          "${REGISTRY}/coder-images/eclipse-temurin:25",
          "${REGISTRY}/coder-images/eclipse-temurin:latest"
        ]
      },
      {
        version = "26"
        upstream = "eclipse-temurin:26-jdk-resolute"
        tags = ["${REGISTRY}/coder-images/eclipse-temurin:26"]
      }
    ]
  }

  name = "jdk-${item.version}"
  args = {
    UPSTREAM = item.upstream
    CHANGE_SOURCE = "${CHANGE_SOURCE}"
    JETBRAINS_DOWNLOAD_URL = "${JETBRAINS_DOWNLOAD_URL}"
    FILE_BROWSER_DOWNLOAD_URL = "${FILE_BROWSER_DOWNLOAD_URL}"
  }
  tags = item.tags
}
