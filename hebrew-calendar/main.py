import hdate
import datetime


if __name__ == "__main__":

    years = [
        i
        for i in range(1995, 1995 + 100)
        if hdate.HDate(datetime.date(i, 10, 5), hebrew=False).holiday_name
        == "yom_kippur"
    ]
    print(years)
