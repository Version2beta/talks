from cart import *
import unittest
from expecter import expect

class TestCart(unittest.TestCase):

  def test_empty_cart_is_created(self):
    expect(create_cart()['uuid']) != False
    expect(create_cart()['events']) == []

  def test_event_added_to_an_empty_cart_is_added(self):
    cart = create_cart()
    cart2 = event(cart, {})
    expect(cart2['uuid']) == cart['uuid']
    expect(cart2['events']) != False

  def test_events_added_to_a_cart_exist(self):
    cart = event(create_cart(), {'e1': {}})
    cart2 = event(cart, {'e2': {}})
    expect(len(cart2['events'])) == 2
    expect('e1' in list(cart2['events'][0])) == True
    expect('e2' in list(cart2['events'][1])) == True
    expect('e1' in list(cart2['events'][1])) == False

  def test_events_have_a_timestamp(self):
    cart = event(create_cart(), {'e1': {}})
    expect('timestamp' in list(cart['events'][0])) == True
    expect(cart['events'][0]['timestamp']) > 0

  def test_add_events_accumulate(self):
    cart = event(create_cart(), {'add': {'id': '1', 'qty': 1}})
    cart2 = event(cart, {'add': {'id': '1', 'qty': 1}})
    expect(state(cart2)) == {'1': 2}

  def test_remove_events_decumulate(self):
    cart = event(create_cart(), {'add': {'id': '1', 'qty': 4}})
    cart2 = event(cart, {'remove': {'id': '1', 'qty': 1}})
    expect(state(cart2)) == {'1': 3}

