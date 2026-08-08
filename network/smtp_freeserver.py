#!/usr/bin/env python3

from aiosmtpd.controller import Controller
from email.parser import BytesParser
from time import sleep
from urllib.parse import unquote

class Handler:
    async def handle_DATA(self, server, session, envelope):
        # envelope.content is bytes
        msg = BytesParser().parsebytes(envelope.content)
        print("From:", msg.get('From'))
        print("To:", msg.get('To'))
        print("Subject:", msg.get('Subject'))
        body = msg.get_payload(decode=True)
        print("\nBody:", body)
        try:
            print("\nDecode:", unquote(body))
        except:
            pass
        
        with open("latest_email.eml", "wb") as f:
            f.write(envelope.content)
        
        return '250 Message accepted for delivery'

if __name__ == "__main__":
    handler = Handler()
   
    controller = Controller(handler, hostname='0.0.0.0', port=25)
    controller.start()
    print("SMTP server listening on 0.0.0.0:25 (press Ctrl+C to stop)")
    try:
        while True:
            sleep(1)
    except KeyboardInterrupt:
        controller.stop()
