from locust import FastHttpUser, task, between
from locust.runners import STATE_STOPPING, STATE_STOPPED, STATE_CLEANUP
from locust import events

class MyUser(FastHttpUser):
    host = "http://192.168.56.50"
    wait_time = between(1, 5)  # Optional: adjust as needed

    @task
    def get_root(self):
        self.client.get("/")

    @task
    def get_dashboard(self):
        self.client.get("/dashboard")

    @task
    def get_page_one(self):
        self.client.get("?page=1")

