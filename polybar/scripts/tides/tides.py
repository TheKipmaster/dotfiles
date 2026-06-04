#!/usr/bin/env python3
import datetime as dt

from tides_data import TidesData
from tides_chart import generate_chart

def next_low(tides: TidesData, date: dt.datetime) -> str:
    today = dt.datetime.today()

    for time, height in tides.get_data_for(date).items():
        time_obj = dt.datetime.strptime(time, "%H:%M").time()
        datetime = dt.datetime.combine(date, time_obj)

        if datetime > today and height < 1.5:
            return time, height
        
    return next_low(tides, date + dt.timedelta(days=1))


def main():
    tides = TidesData()

    time, height = next_low(tides, dt.datetime.today())

    print(time, '-', height)
    generate_chart()


if __name__ == "__main__":
    main()