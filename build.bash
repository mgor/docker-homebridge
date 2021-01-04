#!/usr/bin/env bash

main() {
    local registry="$1"
    local tag="homebridge"
    local tag_latest="${tag}:latest"
    local tag_version

    DOCKER_BUILDKIT=1 docker image build -t "${tag_latest}" . || return $?

    #local id
    #id="$(docker create "${tag}:latest")"
    #docker cp "${id}:/opt/papermc/server.jar" server.zip || return $?
    #docker rm "${id}" > /dev/null

    #local mcver pcver
    #mcver="$(get_version "patch.properties")"
    #pcver="$(get_version "META-INF/maven/io.papermc/paperclip-java8/pom.properties")"
    #pcver="${pcver%-SNAPSHOT}"

    #rm server.zip &> /dev/null || true

    #tag_version="${tag}:${mcver}-${pcver}"

    #docker image tag "${tag_latest}" "${tag_version}"
    #echo "tagged ${tag_latest} with ${tag_version}"

    if [[ -n "${registry}" ]]; then
        docker login
        for t in "${registry}/${tag_latest}" "${registry}/${tag_version}"; do
            docker image tag "${tag_latest}" "${t}"
            docker image push "${t}"
        done
    fi

    return $?
}

main "$@"
exit $?

