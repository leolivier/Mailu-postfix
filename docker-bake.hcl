#### SPECIFIC VARIABLES MUST BE SPECIFIED IN OVERRIDE FILE
variable "DEFAULT_TARGET" {
  default = ""
}
variable "DEFAULT_IMAGE" {
  default = ""
}


#### COMMON VARIABLES
variable "DOCKER_ORG" {
  default = "mailu"
}
variable "DOCKER_PREFIX" {
  default = ""
}
variable "PINNED_MAILU_VERSION" {
  default = "local"
}
variable "MAILU_TAG" {
  default = "local"
}

# -----------------------------------------------------------------------------------------
group "default" {
  targets = [
    "default"
  ]
}

target "defaults" {
  platforms = [ "linux/amd64", "linux/arm64", "linux/arm/v7" ]
  dockerfile="Dockerfile"
}

# -----------------------------------------------------------------------------------------
function "tag" {
  params = [image_name]
  result = [ "${DOCKER_ORG}/${DOCKER_PREFIX}${image_name}:${PINNED_MAILU_VERSION}", 
             "${DOCKER_ORG}/${DOCKER_PREFIX}${image_name}:${MAILU_TAG}",
             "${DOCKER_ORG}/${DOCKER_PREFIX}${image_name}:latest" 
          ]
}

# -----------------------------------------------------------------------------------------
function "cache-from" {
  params = [target]
  result = [
    "user/app:cache",
    "type=local,src=/tmp/buildx-cache-${target}"
  ]
}

# -----------------------------------------------------------------------------------------
function "cache-to" {
  params = [target]
  result = ["type=local,dest=/tmp/buildx-cache-${target}"]
}



target "default" {
  inherits = ["defaults"]
  tags = tag("${DEFAULT_IMAGE}")
  cache-from = cache-from("${DEFAULT_TARGET}")
  cache-to = cache-to("${DEFAULT_TARGET}")
}
