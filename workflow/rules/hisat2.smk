# 4. hisat2比对
rule hisat2:
    input:
        r1 = "results/{sample}/trim/trim_R1.fastq.gz",
        r2 = "results/{sample}/trim/trim_R2.fastq.gz",
    output:
        temp("results/{sample}/hisat2/{sample}.sam")
    log:
        "results/{sample}/logs/hisat2.log"
    conda:
        "../envs/rna.yaml"
    threads: workflow.cores * 0.5
    benchmark:
        "results/{sample}/benchmarks/hisat2.benchmark.txt"
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
        "results/{sample}/hisat2/{sample}.sam"
    output:
        protected("results/{sample}/hisat2/{sample}.bam")
    log:
        "results/{sample}/logs/hisat2.log"
    conda:
        "../envs/rna.yaml"
    threads: workflow.cores * 0.5
    benchmark:
        "results/{sample}/benchmarks/fastqc.sam2bam.txt"
    shell:
        """
        samtools view {input} -q {threads} -h -S -b -o {output}> {log} 2>&1
        """