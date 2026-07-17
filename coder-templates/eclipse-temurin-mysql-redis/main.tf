terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}


locals {
  username = data.coder_workspace_owner.me.name
}

variable "docker_socket" {
  default     = ""
  description = "(Optional) Docker socket URI"
  type        = string
}

data "coder_parameter" "jdk_version" {
  name        = "JDK version"
  type        = "string"
  mutable     = true
  order       = 1
  form_type   = "dropdown"

  option {
    name  = "JDK 26"
    value = "harbor.cluster.internal/coder-images/eclipse-temurin:26"
  }

  option {
    name  = "JDK 25"
    value = "harbor.cluster.internal/coder-images/eclipse-temurin:25"
  }

  option {
    name  = "JDK 21"
    value = "harbor.cluster.internal/coder-images/eclipse-temurin:21"
  }

  option {
    name  = "JDK 17"
    value = "harbor.cluster.internal/coder-images/eclipse-temurin:17"
  }

  option {
    name  = "JDK 11"
    value = "harbor.cluster.internal/coder-images/eclipse-temurin:11"
  }

  option {
    name  = "JDK 8"
    value = "harbor.cluster.internal/coder-images/eclipse-temurin:8"
  }
}

data "coder_parameter" "mysql_version" {
  name        = "MySQL version"
  description = "Please select MySQL version"
  type        = "string"
  mutable     = true
  form_type   = "dropdown"
  icon        = "/icon/database.svg"
  order       = 2

  option {
    name  = "MySQL 9.7.0"
    value = "mysql:9.7.0"
  }

  option {
    name  = "MySQL 8.4.9"
    value = "mysql:8.4.9"
  }
}

data "coder_parameter" "mysql_database" {
  name        = "MySQL Database"
  type        = "string"
  mutable     = false
  order       = 3
}

data "coder_parameter" "mysql_root_password" {
  name        = "MySQL root password"
  type        = "string"
  mutable     = false
  order       = 4
}

data "coder_parameter" "redis_version" {
  name        = "Redis version"
  type        = "string"
  mutable     = true
  order       = 5
  form_type   = "dropdown"

  option {
    name  = "Redis 8.8.0"
    value = "redis:8.8.0"
  }

  option {
    name  = "Redis 8.6.2"
    value = "redis:8.6.2"
  }

  option {
    name  = "Redis 8.4.2"
    value = "redis:8.4.2"
  }

  option {
    name  = "Redis 8.2.5"
    value = "redis:8.2.5"
  }

  option {
    name  = "Redis 8.0.6"
    value = "redis:8.0.6"
  }

  option {
    name  = "Redis 7.4.8"
    value = "redis:7.4.8"
  }
}

provider "docker" {
  # Defaulting to null if the variable is an empty string lets us have an optional variable without having to set our own default
  host = var.docker_socket != "" ? var.docker_socket : null
  ssh_opts = [
    "-o", "StrictHostKeyChecking=no",
    "-o", "UserKnownHostsFile=/dev/null",
    "-i", "/home/coder/.ssh/id_rsa"
  ]
}

data "coder_provisioner" "me" {}
data "coder_workspace" "me" {}
data "coder_workspace_owner" "me" {}

resource "coder_agent" "main" {
  arch           = data.coder_provisioner.me.arch
  os             = "linux"
  startup_script = <<-EOT
    set -e

    # Prepare user home with default files on first start.
    if [ ! -f ~/.init_done ]; then
      cp -rT /etc/skel ~
      touch ~/.init_done
    fi

    # Add any commands that should be executed at workspace startup (e.g install requirements, start a program, etc) here
  EOT

  # These environment variables allow you to make Git commits right away after creating a
  # workspace. Note that they take precedence over configuration defined in ~/.gitconfig!
  # You can remove this block if you'd prefer to configure Git manually or using
  # dotfiles. (see docs/dotfiles.md)
  env = {
    GIT_AUTHOR_NAME     = coalesce(data.coder_workspace_owner.me.full_name, data.coder_workspace_owner.me.name)
    GIT_AUTHOR_EMAIL    = "${data.coder_workspace_owner.me.email}"
    GIT_COMMITTER_NAME  = coalesce(data.coder_workspace_owner.me.full_name, data.coder_workspace_owner.me.name)
    GIT_COMMITTER_EMAIL = "${data.coder_workspace_owner.me.email}"
  }

  # The following metadata blocks are optional. They are used to display
  # information about your workspace in the dashboard. You can remove them
  # if you don't want to display any information.
  # For basic resources, you can use the `coder stat` command.
  # If you need more control, you can write your own script.
  metadata {
    display_name = "CPU Usage"
    key          = "0_cpu_usage"
    script       = "coder stat cpu"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "RAM Usage"
    key          = "1_ram_usage"
    script       = "coder stat mem"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "Home Disk"
    key          = "3_home_disk"
    script       = "coder stat disk --path $${HOME}"
    interval     = 60
    timeout      = 1
  }

  metadata {
    display_name = "CPU Usage (Host)"
    key          = "4_cpu_usage_host"
    script       = "coder stat cpu --host"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "Memory Usage (Host)"
    key          = "5_mem_usage_host"
    script       = "coder stat mem --host"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "Load Average (Host)"
    key          = "6_load_host"
    # get load avg scaled by number of cores
    script   = <<EOT
      echo "`cat /proc/loadavg | awk '{ print $1 }'` `nproc`" | awk '{ printf "%0.2f", $1/$2 }'
    EOT
    interval = 60
    timeout  = 1
  }

  metadata {
    display_name = "Swap Usage (Host)"
    key          = "7_swap_host"
    script       = <<EOT
      free -b | awk '/^Swap/ { printf("%.1f/%.1f", $3/1024.0/1024.0/1024.0, $2/1024.0/1024.0/1024.0) }'
    EOT
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name  = "Database Hostname"
    key           = "8_database_hostname"
    script        = "echo ${docker_container.mysql.name}"
    interval      = 86400
    timeout       = 1
  }

  metadata {
    display_name  = "Redis Hostname"
    key           = "9_database_hostname"
    script        = "echo ${docker_container.redis.name}"
    interval      = 86400
    timeout       = 1
  }
}

resource "coder_app" "jetbrains" {
  agent_id   = coder_agent.main.id
  slug       = "jetbrains"
  display_name = "JetBrains"
  icon       = "/icon/jetbrains-toolbox.svg"
  external   = true
  url = join("", [
    "jetbrains://gateway/coder?",
    "url=",      data.coder_workspace.me.access_url,
    "&token=",   "$SESSION_TOKEN",
    "&workspace=", data.coder_workspace.me.name,
    "&owner=",   data.coder_workspace_owner.me.name,
    "&agent_name=", "main",
  ])
  tooltip = "Opens this workspace in JetBrains Toolbox (requires [JetBrains Toolbox App](https://www.jetbrains.com.cn/toolbox-app/) installed locally)"
}

module "personalize" {
  count    = data.coder_workspace.me.start_count
  source   = "registry.coder.com/coder/personalize/coder"
  version  = "1.0.32"
  agent_id = coder_agent.main.id
}


module "filebrowser" {
  count    = data.coder_workspace.me.start_count
  source   = "registry.coder.com/coder/filebrowser/coder"
  version  = "1.1.5"
  agent_id = coder_agent.main.id
  folder   = "/root"
  agent_name = "main"
  subdomain  = false
}

resource "docker_volume" "home_volume" {
  name = "coder-${data.coder_workspace.me.id}-home"
  # Protect the volume from being deleted due to changes in attributes.
  lifecycle {
    ignore_changes = all
  }
  # Add labels in Docker to keep track of orphan resources.
  labels {
    label = "coder.owner"
    value = data.coder_workspace_owner.me.name
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace_owner.me.id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  # This field becomes outdated if the workspace is renamed but can
  # be useful for debugging or cleaning out dangling volumes.
  labels {
    label = "coder.workspace_name_at_creation"
    value = data.coder_workspace.me.name
  }
}

resource "docker_volume" "mysql_data" {
  name = "coder-${data.coder_workspace.me.id}-mysql"
  # Protect the volume from being deleted due to changes in attributes.
  lifecycle {
    ignore_changes = all
  }
  # Add labels in Docker to keep track of orphan resources.
  labels {
    label = "coder.owner"
    value = data.coder_workspace_owner.me.name
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace_owner.me.id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  # This field becomes outdated if the workspace is renamed but can
  # be useful for debugging or cleaning out dangling volumes.
  labels {
    label = "coder.workspace_name_at_creation"
    value = data.coder_workspace.me.name
  }
}

resource "docker_volume" "redis_data" {
  name = "coder-${data.coder_workspace.me.id}-redis"
  # Protect the volume from being deleted due to changes in attributes.
  lifecycle {
    ignore_changes = all
  }
  # Add labels in Docker to keep track of orphan resources.
  labels {
    label = "coder.owner"
    value = data.coder_workspace_owner.me.name
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace_owner.me.id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  # This field becomes outdated if the workspace is renamed but can
  # be useful for debugging or cleaning out dangling volumes.
  labels {
    label = "coder.workspace_name_at_creation"
    value = data.coder_workspace.me.name
  }
}

resource "docker_network" "workspace" {
  name = "coder-${data.coder_workspace_owner.me.name}-${lower(data.coder_workspace.me.name)}"
}

resource "docker_container" "workspace" {
  count = data.coder_workspace.me.start_count
  image = data.coder_parameter.jdk_version.value
  # Uses lower() to avoid Docker restriction on container names.
  name = "coder-${data.coder_workspace_owner.me.name}-${lower(data.coder_workspace.me.name)}"
  # Hostname makes the shell more user friendly: coder@my-workspace:~$
  hostname = data.coder_workspace.me.name
  # Use the docker gateway if the access URL is 127.0.0.1
  entrypoint = ["sh", "-c", replace(coder_agent.main.init_script, "/localhost|127\\.0\\.0\\.1/", "host.docker.internal")]
  env        = ["CODER_AGENT_TOKEN=${coder_agent.main.token}"]
  networks_advanced {
    name = docker_network.workspace.name
  }
  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }
  volumes {
    container_path = "/root"
    volume_name    = docker_volume.home_volume.name
    read_only      = false
  }

  # Add labels in Docker to keep track of orphan resources.
  labels {
    label = "coder.owner"
    value = data.coder_workspace_owner.me.name
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace_owner.me.id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  labels {
    label = "coder.workspace_name"
    value = data.coder_workspace.me.name
  }
}

resource "docker_container" "mysql" {
  name  = "coder-${data.coder_workspace_owner.me.name}-${lower(data.coder_workspace.me.name)}-mysql"
  image = data.coder_parameter.mysql_version.value
  restart = "on-failure"
  networks_advanced {
    name = docker_network.workspace.name
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${data.coder_parameter.mysql_root_password.value}",
    "MYSQL_DATABASE=${data.coder_parameter.mysql_database.value}"
  ]

  volumes {
    volume_name    = docker_volume.mysql_data.name
    container_path = "/var/lib/mysql"
    read_only      = false
  }

    labels {
    label = "coder.owner"
    value = data.coder_workspace_owner.me.name
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace_owner.me.id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  labels {
    label = "coder.workspace_name"
    value = data.coder_workspace.me.name
  }
}

resource "docker_container" "redis" {
  name  = "coder-${data.coder_workspace_owner.me.name}-${lower(data.coder_workspace.me.name)}-redis"
  image = data.coder_parameter.redis_version.value
  restart = "on-failure"
  networks_advanced {
    name = docker_network.workspace.name
  }

  volumes {
    volume_name    = docker_volume.redis_data.name
    container_path = "/data"
    read_only      = false
  }

  labels {
    label = "coder.owner"
    value = data.coder_workspace_owner.me.name
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace_owner.me.id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  labels {
    label = "coder.workspace_name"
    value = data.coder_workspace.me.name
  }
}
