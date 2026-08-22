#!/usr/bin/env python3
"""Release and landing invariants for joan-kernelsu.

Seams: documented SHA256, KernelSU pin, required patches, landing copy.
Independent expected values live in this file (the published release pin),
not copied from the HTML at runtime.
"""
from __future__ import annotations

import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

PINNED_KSU = "a54e4fa46c6cc25bcaa055cf14d790194beffed8"
PINNED_SHA256 = "fe3c538e32a549f457643d158a49e17e07bc164659ab97d2ad39623d0bc10660"
REQUIRED_PATCHES = (
    "kernel-integration.diff",
    "kernelsu-next-linux-4.4-compat.diff",
    "manual-hooks-linux-4.4.diff",
    "post-kernelsu.diff",
)
SHA256_LINE = re.compile(r"^[0-9a-f]{64}  kernelsu-next-boot\.img\n\Z")


class Sha256FileTests(unittest.TestCase):
    def test_checksum_file_matches_published_pin(self) -> None:
        text = (ROOT / "kernelsu-next-boot.img.sha256").read_text()
        self.assertRegex(text, SHA256_LINE)
        self.assertTrue(text.startswith(PINNED_SHA256))


class DocumentationPinTests(unittest.TestCase):
    def test_sha256_is_quoted_in_release_docs(self) -> None:
        for rel in (
            "README.md",
            "RELEASE.md",
            "GITHUB_RELEASE_BODY.md",
            "docs/index.html",
        ):
            with self.subTest(rel=rel):
                self.assertIn(PINNED_SHA256, (ROOT / rel).read_text())

    def test_prepare_source_pins_legacy_commit(self) -> None:
        script = (ROOT / "prepare-source.sh").read_text()
        self.assertIn(f'KSU_REF="${{KSU_REF:-{PINNED_KSU}}}"', script)
        self.assertIn("set -euo pipefail", script)


class PatchInventoryTests(unittest.TestCase):
    def test_required_patches_exist(self) -> None:
        for name in REQUIRED_PATCHES:
            path = ROOT / "patches" / name
            with self.subTest(name=name):
                self.assertTrue(path.is_file(), f"missing {path}")
                self.assertGreater(path.stat().st_size, 100)


class LandingPageTests(unittest.TestCase):
    def setUp(self) -> None:
        self.html = (ROOT / "docs/index.html").read_text()

    def test_skip_link_and_reduced_motion(self) -> None:
        self.assertIn('href="#main"', self.html)
        self.assertIn("prefers-reduced-motion", self.html)

    def test_primary_cta_and_fastbootd(self) -> None:
        self.assertIn("Download boot image", self.html)
        self.assertIn("fastbootd", self.html.lower())
        self.assertIn("adb reboot fastboot", self.html)

    def test_device_and_rom_identity(self) -> None:
        self.assertIn("joan", self.html)
        self.assertIn("H930", self.html)
        self.assertIn("20260816", self.html)
        self.assertIn("33193", self.html)

    def test_vibecoded_disclaimer(self) -> None:
        self.assertIn("This site is", self.html)
        self.assertIn("vibecoded", self.html)
        self.assertIn("The kernel is not", self.html)

    def test_canonical_and_title(self) -> None:
        self.assertIn("LG V30 Root 2026", self.html)
        self.assertIn("https://tosterino.github.io/joan-kernelsu/", self.html)

    def test_copy_button_uses_published_hash(self) -> None:
        self.assertIn(f'data-copy="{PINNED_SHA256}"', self.html)

    def test_script_is_deferred(self) -> None:
        self.assertIn("<script defer>", self.html)

    def test_copy_has_clipboard_fallback(self) -> None:
        self.assertIn("execCommand", self.html)
        self.assertIn("selectHash", self.html)
        self.assertIn("Hash selected", self.html)


if __name__ == "__main__":
    unittest.main()
