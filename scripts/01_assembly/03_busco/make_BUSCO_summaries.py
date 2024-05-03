import os
import shutil
import glob

BUSCO_summaries = "./BUSCO_summaries"

os.makedirs(BUSCO_summaries, exist_ok=True)
folders = [folder for folder in os.listdir() if os.path.isdir(folder)]

for folder in folders:
    folder_path = os.path.join(os.getcwd(), folder)
    summaries = glob.glob(os.path.join(folder_path, "*.txt"))

    for summary in summaries:
        file_name = os.path.basename(summary)
        new_file_name = file_name.replace("BUSCO_", "")
        new_file_name = new_file_name.replace("good.", "good_")
        destination_path = os.path.join(BUSCO_summaries, new_file_name)
        shutil.copy(summary, destination_path)
