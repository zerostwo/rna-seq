## 6. 计数
rule featureCounts:
    input:
        "results/{sample}/hisat2/{sample}.bam"
    output:
        "results/{sample}/featureCounts/{sample}.counts.txt"
    log:
        "results/{sample}/logs/featureCounts.log"
    conda:
        "../envs/rna.yaml"
    threads: workflow.cores * 0.5
    params:
        gtf = config["gtf"]
    benchmark:
        "results/{sample}/benchmarks/featureCounts.benchmark.txt"
    shell:
        """
        featureCounts -T {threads} -p -t exon -g gene_name -a {params.gtf} \
            -o {output} {input} > {log} 2>&1
        """