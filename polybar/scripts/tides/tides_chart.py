#!/usr/bin/env python3
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import datetime as dt
import numpy as np

from tides_data import TidesData

DAYS = 3
OUT  = '/tmp/tides_chart.png'


def t_to_minutes(time_str, day_offset=0):
    h, m = map(int, time_str.split(':'))
    return day_offset * 1440 + h * 60 + m


def cosine_interp_segment(t1, h1, t2, h2, n=100):
    t_dense = np.linspace(t1, t2, n)
    frac = (t_dense - t1) / (t2 - t1)
    return t_dense, h1 + (h2 - h1) * (1 - np.cos(np.pi * frac)) / 2


def generate_chart():
    tides = TidesData()
    today = dt.datetime.today()

    all_times, all_heights = [], []
    for day in range(DAYS):
        data = tides.get_data_for(today + dt.timedelta(days=day))
        for t, h in data.items():
            all_times.append(t_to_minutes(t, day))
            all_heights.append(h)

    xs, ys = [], []
    for i in range(len(all_times) - 1):
        x, y = cosine_interp_segment(all_times[i], all_heights[i], all_times[i+1], all_heights[i+1])
        xs.append(x)
        ys.append(y)

    x_all = np.concatenate(xs)
    y_all = np.concatenate(ys)

    plt.style.use('dark_background')
    fig, ax = plt.subplots(figsize=(12, 4))

    ax.plot(x_all, y_all, color='#8be9fd', linewidth=2)
    ax.fill_between(x_all, y_all, alpha=0.15, color='#8be9fd')

    now_min = today.hour * 60 + today.minute
    ax.axvline(x=now_min, color='#ff5555', linestyle='--', alpha=0.8)

    for day in range(1, DAYS):
        ax.axvline(x=day * 1440, color='white', alpha=0.15, linewidth=1)

    def format_tick(x, pos):
        total_min = int(x)
        day_n = total_min // 1440
        hm    = total_min % 1440
        h, m  = divmod(hm, 60)
        if hm == 0:
            label = (today + dt.timedelta(days=day_n)).strftime('%a')
            return f"{label}\n00:00"
        return f"{h:02d}:{m:02d}"

    ax.xaxis.set_major_locator(ticker.MultipleLocator(360))
    ax.xaxis.set_major_formatter(ticker.FuncFormatter(format_tick))

    ax.set_ylabel('meters')
    ax.set_ylim(bottom=0)
    ax.set_xlim(x_all[0], x_all[-1])
    ax.set_title(f"Tides — Cabedelo — {today.strftime('%Y-%m-%d')}")
    fig.tight_layout()

    fig.savefig(OUT, dpi=120)
    plt.close(fig)

if __name__ == "__main__":
    generate_chart()
