#!/usr/bin/env python3
from tides_data import TidesData

def next_low(tides: TidesData) -> str:
    for time, height in tides.todays_data().items():
        if tides.format_time(time) > tides.today.time() and height < 1.5:
            return time, height
        
    return next_low(TidesData(tides.tomorrow))


def main():
    tides = TidesData()

    time, height = next_low(tides)

    print(time, '-', height)


if __name__ == "__main__":
    main()