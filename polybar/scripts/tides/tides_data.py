
from os import path
import json
import datetime as dt

class TidesData():
    def __init__(
        self, json_path='mare_cabedelo_2026.json',
        locale='Cabedelo', datetime=dt.datetime.today()
    ):
        self._json_path = path.join(path.dirname(path.abspath(__file__)), json_path)
        self._locale = locale
        self._today = datetime

        with open(self.json_path, 'r') as file:
            self._data = json.load(file)

    @property
    def json_path(self) -> str:
        return self._json_path

    @property
    def locale(self) -> str:
        return self._locale

    @property
    def today(self) -> dt.datetime:
        return self._today

    @property
    def tomorrow(self) -> dt.datetime:
        return self.today + dt.timedelta(days=1)

    @property
    def date_str(self) -> str:
        return self.today.strftime('%Y-%m-%d')

    @property
    def data(self) -> dict:
        return self._data

    def format_time(self, time_str: str) -> dt.datetime.time:
        return dt.datetime.strptime(time_str, '%H:%M').time()

    def todays_data(self) -> dict:
        return self.data[self.date_str]
