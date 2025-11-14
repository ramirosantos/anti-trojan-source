# anti-trojan-source

**Detect and block Unicode-based "Trojan Source" and "Glassworm"-style supply-chain attacks.**

## Author

This is the container version of the tool by [**Liran Tal**](https://github.com/lirantal), published at [anti-trojan-source](https://github.com/lirantal/anti-trojan-source). All rights belong to **Liran Tal**. For further information, please visit his original page

---

## What This Image Does
It detects cases of trojan source attacks that employ unicode bidi attacks to inject malicious code, as well as other attacks that use confusable characters (such as glassworm attacks). The tool uses both an explicit list of dangerous Unicode characters and category-based detection to catch invisible characters by their Unicode category (Format and Control categories).

**What it is:**  
*Glassworm* — a self-propagating supply-chain attack on VS Code extensions — hides payloads using invisible Unicode (“Trojan Source”–style), making malicious code invisible to reviewers and diffs.

**Impact:**  
35,800+ installs compromised; command & control infrastructure remains active.

**How it spreads:**  
Steals developer credentials and leverages infected extensions to propagate.

**Why it’s tricky:**  
Exploits *bidi controls*, *zero-width characters*, and *variation selectors* that many IDEs and diff tools fail to render or highlight.

**How to defend:**  
Use **anti-trojan-source** to automatically scan code for invisible Unicode, detect both known and category-based risks, and integrate into CI pipelines. Do **not** rely on visual inspection alone.

---

| **Attribute** | **Details** |
|-----------|-----------|
| **Docker Image** | cb2dolw/anti-trojan-source |
| **Author** | Ramiro Santos |
| **References** | https://snyk.io/de/articles/defending-against-glassworm/<br>https://github.com/lirantal/anti-trojan-source |

---

## Example usage

```bash
# Display help
docker run --rm cb2dolw/anti-trojan-source --help

# Scan a single file
docker run --rm -v "$PWD":/data cb2dolw/anti-trojan-source --files /data/file-to-scan

# Verbose TUI (pseudo-TTY wrapper)
docker run --rm -v "$PWD":/data cb2dolw/anti-trojan-source --files /data/file-to-scan --verbose

# Default scan of all files under /data with JSON output
docker run --rm -v "$PWD":/data cb2dolw/anti-trojan-source --json
```

---

## Supported Architectures
- linux/amd64
- linux/arm64


