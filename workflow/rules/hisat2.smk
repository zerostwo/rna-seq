# 4. hisat2比对
rule hisat2:
    input:
        r1 = "results/trim/{sample}_R1.trim.fastq.gz",
        r2 = "results/trim/{sample}_R2.trim.fastq.gz",
    output:
        temp("results/hisat2/{sample}.sam")
    log:
        "results/logs/{sample}.hisat2.log"
    conda:
        "../envs/rna.yaml"
    threads: workflow.cores * 0.5
    benchmark:
        "results/benchmarks/{sample}.hisat2.benchmark.txt"
    params:
        index = config["index"]
    shell:
        """
        hisat2 -p {threads} -N 1 --dta -x {params} \
            -1 {input.r1} \
            -2 {input.r2} \
            -S  {output}> {log} 2>&1
        """
rule sam2bam:
    input:
        "results/hisat2/{sample}.sam"
    output:
        protected("results/hisat2/{sample}.bam")
    log:
        "results/logs/{sample}.hisat2.log"
    conda:
        "../envs/rna.yaml"
    threads: workflow.cores * 0.5
    benchmark:
        "results/benchmarks/{sample}.sam2bam.benchmark.txt"
    shell:
        """
        samtools view {input} -q {threads} -h -S -b -o {output}> {log} 2>&1
        """