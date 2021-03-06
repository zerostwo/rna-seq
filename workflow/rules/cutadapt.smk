# 2. 去接头序列
rule cutadapt:
    input:
        r1 = "resources/{sample}_R1.fastq.gz",
        r2 = "resources/{sample}_R2.fastq.gz"
    output:
        cutadapt_r1 = temp("results/cutadapt/{sample}_R1.cutadapt.fastq.gz"),
        cutadapt_r2 = temp("results/cutadapt/{sample}_R2.cutadapt.fastq.gz")
    log:
        "results/logs/{sample}.cutadapt.log"
    conda:
        "../envs/rna.yaml"
    threads: workflow.cores * 0.5
    benchmark:
        "results/benchmarks/{sample}.cutadapt.benchmark.txt"
    shell:
        """
        cutadapt -a AGATCGGAAGAG -A AGATCGGAAGAG \
            -j {threads} \
            -o {output.cutadapt_r1} \
            -p {output.cutadapt_r2} \
            {input.r1} {input.r2} > {log} 2>&1
        """