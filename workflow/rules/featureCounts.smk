def get_featureCounts_input(SAMPLES):
    return ["results/hisat2/{S}.bam".format(S=sample) for sample in SAMPLES]

## 6. 计数
rule featureCounts:
    input:
        get_featureCounts_input(SAMPLES)
    output:
        "results/featureCounts/all.counts.txt"
    log:
        "results/logs/all.featureCounts.log"
    conda:
        "../envs/rna.yaml"
    threads: workflow.cores
    params:
        gtf = config["gtf"]
    benchmark:
        "results/benchmarks/all.featureCounts.benchmark.txt"
    shell:
        """
        featureCounts -T {threads} -p -t exon -g gene_name -a {params.gtf} \
            -o {output} {input} > {log} 2>&1
        """