import os
import shutil
import zipfile

SUBMISSIONS_FOLDER = "submissions"
MACOSX_FOLDER = "__MACOSX"

def make_student_directories():
  num_students = 0
  for file in os.listdir(os.curdir):
    if file[0] != '.' and os.path.isfile(file):
      student_name = file.split("_")[0].split('--')
      student_name = '-'.join(student_name)
      if not os.path.isdir(student_name):
        os.mkdir(student_name)
        num_students += 1
      filename = file.split("_")[-1]
      shutil.move(file, student_name + "/" + filename)
  print num_students, " directories created"

def unzip_submissions():
  num_unzipped = 0
  for file in os.listdir(os.curdir):
    if file[0] != '.' and os.path.isdir(file):
      for student_file in os.listdir(file):
        if os.path.splitext(student_file)[1] == ".zip":
          os.chdir(file)
          zipped_file = zipfile.ZipFile(student_file)
          zipped_file.extractall()
          os.remove(student_file)
          num_unzipped += 1

          if MACOSX_FOLDER in os.listdir(os.curdir):
            shutil.rmtree(MACOSX_FOLDER)

          if len(os.listdir(os.curdir)) == 1:
            the_only_thing = os.listdir(os.curdir)[0]
            if os.path.isdir(the_only_thing):
              for foldered_file in os.listdir(the_only_thing):
                shutil.copy2(os.path.join(the_only_thing, foldered_file), os.curdir)
              shutil.rmtree(the_only_thing)

          os.chdir(os.pardir)
  print num_unzipped, " files unzipped"

if __name__ == '__main__':
  os.chdir(SUBMISSIONS_FOLDER)
  make_student_directories()
  unzip_submissions()