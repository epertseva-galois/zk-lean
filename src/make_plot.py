import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Load CSV
df = pd.read_csv("results.csv", skipinitialspace=True)

# Parameters
THRESH = 179.0  # only count solves under this
Y_MAX = 90    # top of y-axis
Y_STEP = 30     # increment every 10 seconds
X_MAX = 10      # show up to 10 solved instances


def cactus_xy(times, thresh):
    solved = np.sort(times[times < thresh].to_numpy())
    x = np.arange(1, len(solved) + 1)
    # Start at (0,0)
    x = np.insert(x, 0, 0)
    solved = np.insert(solved, 0, 0.0)
    return x, solved

# Build cactus data
x_lean, y_lean = cactus_xy(df["Lean"], THRESH)
x_smt,  y_smt  = cactus_xy(df["smt"],  THRESH)

# Plot
plt.figure(figsize=(12, 4))
plt.plot(x_lean, y_lean, label="Lean", color="#9467bd", linestyle="-", linewidth=3)   # purple
plt.plot(x_smt,  y_smt,  label="SMT",  color="orange", linestyle="--", linewidth=3)   # orange dotted

# Axes
plt.xlim(0, X_MAX)
plt.ylim(0, Y_MAX)
plt.xticks(np.arange(0, X_MAX + 1, 1), fontsize=16)
plt.yticks(np.arange(0, Y_MAX + 1, Y_STEP), fontsize=16)

# Labels
plt.xlabel("Solved Instances", fontsize=26)
plt.ylabel("Time (s)", fontsize=26)

# Legend to the right
plt.legend(title="Solver", loc="center left", bbox_to_anchor=(1, 0.5), fontsize=20, title_fontsize=20, frameon=False)  # removes gray box)

# Grid
plt.grid(True, which="major", linestyle="--", linewidth=1.5, alpha=0.7)

ax = plt.gca()
ax.spines["top"].set_visible(False)

plt.tight_layout()
plt.savefig("cactus_plot.png", dpi=600, bbox_inches="tight")  # also try .pdf for vector graphics

plt.show()