# SPDX-License-Identifier: Apache-2.0 WITH Swift-exception
# Copyright (c) 2026 Xudong Xu

import importlib.machinery
import importlib.util
import json
from pathlib import Path
import subprocess
import tempfile
import unittest

loader = importlib.machinery.SourceFileLoader(
    "version_check", str(Path(__file__).resolve().parents[2] / "Scripts/validate-version")
)
spec = importlib.util.spec_from_loader(loader.name, loader)
module = importlib.util.module_from_spec(spec)
loader.exec_module(module)


class VersionTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        (self.root / ".github").mkdir()
        (self.root / ".github/release.json").write_text(json.dumps({
            "repository": "fixture/package", "version_file": "VERSION",
            "version_pattern": "^([^\\n]+)\\n?$", "changelog": "CHANGELOG.md",
        }))
        (self.root / "VERSION").write_text("0.1.0\n")
        (self.root / "CHANGELOG.md").write_text("# Changelog\n\n## 0.1.0\n\n- First release.\n")
        self.git("init", "-q")
        self.git("config", "user.name", "Release fixture")
        self.git("config", "user.email", "release-fixture@example.invalid")
        self.commit()

    def git(self, *arguments):
        return subprocess.check_output(["git", "-C", str(self.root), *arguments], text=True).strip()

    def commit(self):
        self.git("add", ".")
        self.git("commit", "-qm", "test: prepare version fixture")

    def test_tag_must_match_the_accepted_commit(self):
        self.git("tag", "v0.1.0")
        self.assertEqual(module.validate(self.root, "v0.1.0", True)[0]["version"], "0.1.0")
        with self.assertRaises(ValueError):
            module.validate(self.root, "v0.2.0")
        (self.root / "change").write_text("next candidate")
        self.commit()
        with self.assertRaises(ValueError):
            module.validate(self.root, "v0.1.0")

    def test_dirty_source_is_rejected_for_release(self):
        (self.root / "VERSION").write_text("0.2.0\n")
        (self.root / "CHANGELOG.md").write_text("## 0.2.0\n\n- New feature.\n")
        with self.assertRaises(ValueError):
            module.validate(self.root, require_clean=True)

    def test_missing_empty_or_duplicate_notes_are_rejected(self):
        for text in ["## 0.2.0\n- Other release.\n", "## 0.1.0\n", "## 0.1.0\n- A\n## 0.1.0\n- B\n"]:
            with self.subTest(text=text):
                (self.root / "CHANGELOG.md").write_text(text)
                with self.assertRaises(ValueError):
                    module.validate(self.root)

    def test_preview_and_leading_zero_rules(self):
        for version in ["0.1.0-alpha.1", "0.1.0-beta.2", "0.1.0-rc.1"]:
            (self.root / "VERSION").write_text(version + "\n")
            (self.root / "CHANGELOG.md").write_text("## " + version + "\n\n- Preview.\n")
            self.assertEqual(module.validate(self.root)[0]["version"], version)
        for version in ["00.1.0", "0.1.0-alpha.0", "0.1.0-beta.01", "0.1.0-preview.1"]:
            (self.root / "VERSION").write_text(version + "\n")
            with self.assertRaises(ValueError):
                module.validate(self.root)

    def test_checks_leave_inputs_unchanged(self):
        before = self.git("status", "--porcelain")
        module.validate(self.root)
        self.assertEqual(before, self.git("status", "--porcelain"))


if __name__ == "__main__":
    unittest.main()
