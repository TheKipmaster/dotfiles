
from os import path
import json
import datetime as dt

class TidesData():
    def __init__(
        self, json_path='mare_cabedelo_2026.json',
        locale='Cabedelo'
    ):
        self._json_path = path.join(path.dirname(path.abspath(__file__)), json_path)
        self._locale = locale

        with open(self.json_path, 'r') as file:
            self._data = json.load(file)

    @property
    def json_path(self) -> str:
        return self._json_path

    @property
    def locale(self) -> str:
        return self._locale

    def date_str(self, date: dt.datetime) -> str:
        return date.strftime("%Y-%m-%d")

    def get_data_for(self, date: dt.datetime) -> dict:
        return self._data[self.date_str(date)]
