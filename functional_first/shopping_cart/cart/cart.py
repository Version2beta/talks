import uuid
import time

def timestamp(event):
  return dict(event, **{'timestamp': time.time()})

def create_uuid():
  return uuid.uuid4()

def create_cart():
  return {'uuid': create_uuid(), 'events': []}

def event(cart, event):
  return {'uuid': cart['uuid'], 'events': cart['events'] + [timestamp(event)]}

def item_id(item):
  return item.get('id')

def item_qty(item):
  return item.get('qty', 1)

def handle_adds(acc, events):
  for event in events:
    if event.get('add') and event['add'].get('id'):
      add_event = event['add']
      acc[item_id(add_event)] = acc.get(item_id(add_event), 0) + item_qty(add_event)
  return acc

def handle_removes(acc, events):
  for event in events:
    if event.get('remove') and event['remove'].get('id'):
      remove_event = event['remove']
      acc[item_id(remove_event)] = acc.get(item_id(remove_event), 0) - item_qty(remove_event)
  return acc

def state(cart):
  return handle_removes(handle_adds({}, cart.get('events', [])), cart.get('events', []))
