from marshmallow import Schema, fields, validate

class TransactionSchema(Schema):
    amount = fields.Decimal(required=True, validate=validate.Range(min=0.01))
