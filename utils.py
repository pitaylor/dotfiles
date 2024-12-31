import os
from pathlib import Path
from string import Template


def render(source_dir: Path, dest_dir: Path, variables: dict):
    """
    Render templates from a source directory to a destination directory.

    Parameters:
    - source_dir: directory containing template files (*.tmpl).
    - dest_dir: target directory for the rendered files.
    - variables: dictionary of variables to substitute in the templates.
    """
    for source in source_dir.rglob("*.tmpl"):
        target_file = source.relative_to(source_dir).with_suffix("")
        content = source.read_text()
        template = Template(content)

        print(f"Rendering {target_file}")

        try:
            rendered = template.substitute(variables)
        except KeyError as e:
            print(f"  Missing key: {e}. Skipped!")
            continue

        output_file = dest_dir / target_file
        output_file.parent.mkdir(parents=True, exist_ok=True)

        with open(output_file, "w") as f:
            f.write(rendered)

        output_file.chmod(source.stat().st_mode)


def symlink(source_dir: Path, target_dir: Path):
    """
    Create symlinks for files from a source directory to a target directory.

    Parameters:
    - source_dir: path to the source directory from which files will be linked.
    - target_dir: path to the target directory where symlinks will be created.
    """
    for root, _, files in os.walk(source_dir):
        dir_path = Path(root)
        target_path = target_dir / dir_path.relative_to(source_dir)
        target_path.mkdir(parents=True, exist_ok=True)

        for file in files:
            source_file = dir_path / file
            target_file = target_path / file

            if target_file.suffix == ".tmpl":
                continue

            print(f"Linking ~/{target_file.relative_to(target_dir)}")

            if target_file.exists():
                if not target_file.samefile(source_file):
                    print(f"  Conflict found. Skipped!")
            else:
                target_file.unlink(missing_ok=True)
                target_file.symlink_to(source_file)


def inject(source: str, target: Path):
    """
    Append a source script inclusion line to a target file.

    Parameters:
    - source: path to the source script to be appended.
    - target: path to the target file where the source inclusion line will be appended.
    """
    try:
        with target.open() as file:
            if any(source in line for line in file):
                return
    except FileNotFoundError:
        pass

    with target.open("a") as file:
        file.write(f'\n[[ -s "{source}" ]] && source "{source}"\n')
