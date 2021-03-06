rule ILM_Ref_QC_clean_data:
    input: rules.RemovePrimers_pt2.output
    output:
        html    =   f"{datadir + qc_post}" + "{sample}_fastqc.html",
        zip     =   f"{datadir + qc_post}" + "{sample}_fastqc.zip"
    conda:
        f"{conda_envs}QC_and_clean.yaml"
    log:
        f"{logdir}" + "QC_clean_data_{sample}.log"
    benchmark:
        f"{logdir + bench}" + "QC_clean_data_{sample}.txt"
    threads: 6
    resources:
        memory = 12 * 1024
    shell:
        """
if [ -s "{input}" ] # If file exists and is NOT empty (i.e. filesize > 0) do...
then
    fastqc -t 6 --quiet --outdir data/FastQC_posttrim/ {input} > {log} 2>&1
else
    touch {output.html}
    touch {output.zip}
fi
        """