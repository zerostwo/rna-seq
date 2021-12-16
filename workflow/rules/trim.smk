# 3. 去低质量
rule trim:
    input:
        r1 = "results/{sample}/cutadapt/cutadapt_R1.fastq.gz",
        r2 = "results/{sample}/cutadapt/cutadapt_R2.fastq.gz"
    output:
        trim_r1 = temp("results/{sample}/trim/trim_R1.fastq.gz"),
        trim_unpaired_r1 = temp("results/{sample}/trim/trim_unpaired_R1.fastq.gz"),
        trim_r2 = temp("results/{sample}/trim/trim_R2.fastq.gz"),
        trim_unpaired_r2 = temp("results/{sample}/trim/trim_unpaired_R2.fastq.gz")
    log:
        "results/{sample}/logs/trim.log"
    conda:
        "../envs/rna.yaml"
    threads: workflow.cores * 0.5
    benchmark:
        "results/{sample}/benchmarks/trim.benchmark.txt"
    shell:
        """
        trimmomatic PE -threads {threads} -phred33 \
            {input.r1} \
            {input.r2} \
            {output.trim_r1} {output.trim_unpaired_r1} \
            {output.trim_r2} {output.trim_unpaired_r2} \
            LEADING:20 TRAILING:20 SLIDINGWINDOW:4:20 MINLEN:18 > {log} 2>&1
        """