#!/usr/bin/env python3

from os import path
import json
from datetime import datetime as dt

class LoadData():
    def __init__(
        self, json_file='mare_cabedelo_2026.json',
        locale='Cabedelo', datetime=dt.today()
    ):
        self._json_path = path.join(path.dirname(path.abspath(__file__)), json_file)
        self._locale = locale
        self._datetime = datetime

        with open(self.json_path, 'r') as file:
            self._data = json.load(file)
    
    @property
    def json_path(self) -> str:
        return self._json_path
    
    @property
    def locale(self) -> str:
        return self._locale
    
    @property
    def datetime(self) -> dt:
        return self._datetime
    
    @property
    def date_str(self) -> str:
        return self.datetime.strftime('%Y-%m-%d')
    
    @property
    def data(self) -> dict:
        return self._data
    
    def format_time(self, time_str: str) -> dt.time:
        return dt.strptime(time_str, '%H:%M').time()
    
    def todays_data(self) -> dict:
        return self.data[self.date_str]
    
    def next_low(self) -> tuple[str, str]:
        for time, height in self.todays_data().items():
            if self.format_time(time) > self.datetime.time() and height < 1.5:
                return time, height



def main():
    data = LoadData()

    time, height = data.next_low()

    print(time, '-', height)


if __name__ == "__main__":
    main()