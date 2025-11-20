import time
import datetime
from threading import Thread

class Scheduler:
    def __init__(self):
        self.tasks = []

    def schedule(self, time_str, task_fn):
        """
        time_str: string in 'HH:MM' 24-hour format
        task_fn: function to run at that time
        """
        self.tasks.append((time_str, task_fn))

    def check_and_run(self):
        """
        Continuously checks time and runs tasks at scheduled times.
        """
        print("Scheduler started. Waiting for tasks to run...")
        already_run_today = set()

        while True:
            now = datetime.datetime.now()
            current_time = now.strftime("%H:%M")

            for time_str, task in self.tasks:
                task_id = (time_str, task.__name__)
                if current_time == time_str and task_id not in already_run_today:
                    print(f"Running task '{task.__name__}' at {current_time}")
                    Thread(target=task).start()
                    already_run_today.add(task_id)

            # Reset task tracking at midnight
            if now.hour == 0 and now.minute == 0:
                already_run_today.clear()

            time.sleep(30)  # check every 30 seconds

# Example usage:

def my_task():
    print(">>> Task is running!")

def another_task():
    print(">>> Another task executed!")

if __name__ == "__main__":
    scheduler = Scheduler()
    scheduler.schedule("13:00", my_task)       # Run at 13:00
    scheduler.schedule("13:05", another_task)  # Run at 13:05
    scheduler.check_and_run()
