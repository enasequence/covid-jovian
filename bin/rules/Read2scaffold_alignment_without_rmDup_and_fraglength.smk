
#@ # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#@ 
#@ 
#@ # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#TODO This rule is only still included for debugging purposes, this, and the corresponding part in the main snakefile, can be removed in version 1.0

rule Read2scaffold_alignment_without_rmDup_and_fraglength:
    input:
        fasta="data/scaffolds_filtered/{sample}_scaffolds_ge%snt.fasta" % config["scaffold_minLen_filter"]["minlen"],
        pR1="data/cleaned_fastq/{sample}_pR1.fq",
        pR2="data/cleaned_fastq/{sample}_pR2.fq",
    output:
        bam="data/scaffolds_filtered/{sample}_sorted.bam",
        bam_bai="data/scaffolds_filtered/{sample}_sorted.bam.bai",
        txt="data/scaffolds_filtered/{sample}_insert_size_metrics.txt",
        pdf="data/scaffolds_filtered/{sample}_insert_size_histogram.pdf"
    conda:
        "../envs/scaffold_analyses.yaml"
    log:
        "logs/Read2scaffold_alignment_without_rmDup_and_fraglength_{sample}.log"
    benchmark:
        "logs/benchmark/Read2scaffold_alignment_without_rmDup_and_fraglength_{sample}.txt"
    threads: config["threads"]["Fragment_length_analysis"]
    shell:
        """
bwa index {input.fasta} > {log} 2>&1
bwa mem -t {threads} {input.fasta} \
{input.pR1} \
{input.pR2} 2>> {log} |\
samtools view -@ {threads} -uS - 2>> {log} |\
samtools sort -@ {threads} - -o {output.bam} >> {log} 2>&1
samtools index -@ {threads} {output.bam} >> {log} 2>&1
picard -Dpicard.useLegacyParser=false CollectInsertSizeMetrics \
-I {output.bam} \
-O {output.txt} \
-H {output.pdf} >> {log} 2>&1
        """