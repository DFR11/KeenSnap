import os
import re
from deep_translator import GoogleTranslator

def translate_comments_in_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        lines = file.readlines()

    translated_lines = []

    for line in lines:
        if line.startswith('#') or line.startswith('<!--') or line.startswith('*'):
            if line.startswith('#'):
                match = re.match(r'#\s*(.*)', line)
                if match:
                    comment = match.group(1)
            elif line.startswith('<!--'):
                match = re.match(r'<!--\s*(.*)\s*-->', line)
                if match:
                    comment = match.group(1)
            elif line.startswith('*'):
                match = re.match(r'\*\s*(.*)', line)
                if match:
                    comment = match.group(1)

            try:
                translated_comment = GoogleTranslator(source='auto', target='en').translate(comment)
                if line.startswith('#'):
                    translated_lines.append(f"# {translated_comment}\n")
                elif line.startswith('<!--'):
                    translated_lines.append(f"<!-- {translated_comment} -->\n")
                elif line.startswith('*'):
                    translated_lines.append(f"* {translated_comment}\n")
            except Exception as e:
                print(f"Translation error: {e}")
        else:
            translated_lines.append(line)

    with open(file_path, 'w', encoding='utf-8') as file:
        file.writelines(translated_lines)

def translate_project_comments(project_dir):
    for root, dirs, files in os.walk(project_dir):
        for file in files:
            if file.endswith('.sh') or file.endswith('.md'):
                file_path = os.path.join(root, file)
                print(f'Translating comments in: {file_path}')
                translate_comments_in_file(file_path)

project_directory = '.'  # 当前目录
translate_project_comments(project_directory)
