import re
import sys
import textwrap

START_USER = 'govuk::user'
END_USER = '}'

USERNAME_RE = re.compile(r"govuk::user\s+{\s+'([^']+)':")

def indent(text, amount=2):
    return '\n'.join(' ' * amount + line for line in text.splitlines())

def create_user(user, text):
    filename = user + '.pp'
    print("writing " + filename)
    with open(filename, 'w') as f:
        f.write("class users::" + user + " {\n")
        f.write(indent(text) + "\n")
        f.write("}\n")

def main():
    in_user = False
    user = None
    usertext = []
    for line in sys.stdin:
        if not in_user:
            match = USERNAME_RE.search(line)
            if match:
                user = match.group(1)
                in_user = True

        if in_user:
            usertext.append(line)
            if END_USER in line:
                create_user(user, textwrap.dedent(''.join(usertext)))
                in_user = False
                user = None
                usertext = []

if __name__ == '__main__':
    main()
