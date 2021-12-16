# 3. 去低质量
rule trim:
    input:
        r1 = "results/cutadapt/{sample}_R1.cutadapt.fastq.gz",
        r2 = "results/cutadapt/{sample}_R2.cutadapt.fastq.gz",
    output:
        trim_r1 = temp("results/trim/{sample}_R1.trim.fastq.gz"),
        trim_unpaired_r1 = temp("results/trim/{sample}_R1.trim.unpaired.fastq.gz"),
        trim_r2 = temp("results/trim/{sample}_R2.trim.fastq.gz"),
        trim_unpaired_r2 = temp("results/trim/{sample}_R2.trim.unpaired.fastq.gz"),
    log:
        "results/logs/{sample}.trim.log"
    conda:
        "../envs/rna.yaml"
    threads: workflow.cores * 0.5
    benchmark:
        "results/benchmarks/{sample}.trim.benchmark.txt"
    shell:
        """
        trimmomatic PE -threads {threads} -phred33 \
            {input.r1} \
            {input.r2} \
            {output.trim_r1} {output.trim_unpaired_r1} \
            {output.trim_r2} {output.trim_unpaired_r2} \
            LEADING:20 TRAILING:20 SLIDINGWINDOW:4:20 MINLEN:18 > {log} 2>&1
        """