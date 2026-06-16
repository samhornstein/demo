process FASTFETCH {

    conda "${moduleDir}/environment.yml"
    container "${workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container
        ? 'https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/ac/ac9ba7914fe2582a39782a9a6d1fd89738bb68d581123d906162b45496852825/data'
        : 'community.wave.seqera.io/library/fastfetch:2.49.0--eaa90769d7cbc593'}"

    output:
    path ("*.txt"), emit: txt
    tuple val("${task.process}"), val('fastfetch'), eval("fastfetch -v | cut -d ' ' -f 2"), emit: versions_fastfetch, topic: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''

    """
    fastfetch \\
        ${args} \\
        --thread ${task.cpus} \\
        > fastfetch_output.txt
    """

    stub:
    """
    touch fastfetch_output.txt
    """
}
