# Domain Overview | Visão Geral do Domínio

---

# 🇺🇸 English Version

## Overview

This document describes the **core business domain** of the **Repair Shop Management System**.

The purpose of this system is to help repair shops manage:

- Customers
- Devices
- Technicians
- Service Orders
- Payments

The goal is to **model the business domain clearly**, allowing **developers and business stakeholders to share the same understanding of the system**.

---

## Ubiquitous Language

The following concepts define the **shared language used throughout the system**.

---

## Customer

Represents a **client of the repair shop**.

A customer can own **multiple devices** that may require repair services.

### Attributes

| Attribute | Description |
|----------|-------------|
| id | Unique identifier |
| name | Customer name |
| phone | Contact phone |
| email | Contact email |
| created_at | Record creation date |

---

## Device

Represents an **electronic device owned by a customer**.

### Examples

- Smartphone
- Laptop
- Tablet

A device **belongs to one customer**, but may have **multiple service orders over time**.

### Attributes

| Attribute | Description |
|----------|-------------|
| id | Unique identifier |
| customer_id | Owner customer |
| brand | Device brand |
| model | Device model |
| serial_number | Unique serial number |

---

## Technician

Represents a **professional responsible for performing repair services**.

A technician may work on **multiple service orders depending on their specialization**.

### Attributes

| Attribute | Description |
|----------|-------------|
| id | Unique identifier |
| name | Technician name |
| specialization | Area of expertise |
| created_at | Record creation date |

---

## Service Order

Represents a **repair request created for a device**.

A service order may involve:

- Multiple technicians
- Multiple repair services

### Possible Status


OPEN
IN_PROGRESS
WAITING_PART
COMPLETED
CANCELLED


### Attributes

| Attribute | Description |
|----------|-------------|
| id | Unique identifier |
| device_id | Device being repaired |
| status | Current status |
| description | Problem description |
| created_at | Record creation date |

---

## Payment

Represents a **payment made for a service order**.

Payments may be **partial or full**, depending on the business rules.

### Attributes

| Attribute | Description |
|----------|-------------|
| id | Unique identifier |
| service_order_id | Related service order |
| amount | Payment amount |
| payment_method | Payment type |
| created_at | Record creation date |

---

## Business Rules

The system follows the rules below:

- A **customer can own multiple devices**
- A **device belongs to exactly one customer**
- A **device can have multiple service orders over time**
- A **service order can be assigned to multiple technicians**
- A **service order can contain multiple service items**
- **Payments can be partial or full**

---

# 🇧🇷 Versão em Português

## Visão Geral

Este documento descreve o **domínio de negócio do Sistema de Gestão de Assistência Técnica**.

O objetivo do sistema é ajudar assistências técnicas a gerenciar:

- Clientes
- Dispositivos
- Técnicos
- Ordens de Serviço
- Pagamentos

A ideia é **modelar o domínio do negócio de forma clara**, permitindo que **desenvolvedores e especialistas do negócio compartilhem o mesmo entendimento do sistema**.

---

## Linguagem Ubíqua (Ubiquitous Language)

Os conceitos abaixo representam os **principais termos utilizados no sistema**.

---

## Customer (Cliente)

Representa um **cliente da assistência técnica**.

Um cliente pode possuir **vários dispositivos** que podem precisar de reparo.

### Atributos

| Atributo | Descrição |
|---------|-----------|
| id | Identificador único |
| name | Nome do cliente |
| phone | Telefone |
| email | Email |
| created_at | Data de criação |

---

## Device (Dispositivo)

Representa um **dispositivo eletrônico pertencente a um cliente**.

### Exemplos

- Smartphone
- Laptop
- Tablet

Um dispositivo **pertence a um único cliente**, mas pode ter **várias ordens de serviço ao longo do tempo**.

### Atributos

| Atributo | Descrição |
|---------|-----------|
| id | Identificador único |
| customer_id | Cliente proprietário |
| brand | Marca |
| model | Modelo |
| serial_number | Número de série |

---

## Technician (Técnico)

Representa um **profissional responsável por executar serviços de reparo**.

Um técnico pode trabalhar em **várias ordens de serviço dependendo de sua especialização**.

### Atributos

| Atributo | Descrição |
|---------|-----------|
| id | Identificador único |
| name | Nome do técnico |
| specialization | Especialização |
| created_at | Data de criação |

---

## Service Order (Ordem de Serviço)

Representa um **pedido de reparo criado para um dispositivo**.

Uma ordem de serviço pode envolver:

- Múltiplos técnicos
- Vários serviços de reparo

### Possíveis Status


OPEN
IN_PROGRESS
WAITING_PART
COMPLETED
CANCELLED


### Atributos

| Atributo | Descrição |
|---------|-----------|
| id | Identificador único |
| device_id | Dispositivo relacionado |
| status | Status atual |
| description | Descrição do problema |
| created_at | Data de criação |

---

## Payment (Pagamento)

Representa um **pagamento realizado para uma ordem de serviço**.

Os pagamentos podem ser **parciais ou completos**, dependendo das regras de negócio.

### Atributos

| Atributo | Descrição |
|---------|-----------|
| id | Identificador único |
| service_order_id | Ordem de serviço associada |
| amount | Valor pago |
| payment_method | Método de pagamento |
| created_at | Data de criação |

---

## Regras de Negócio

O sistema segue as seguintes regras:

- Um **cliente pode possuir vários dispositivos**
- Um **dispositivo pertence a apenas um cliente**
- Um **dispositivo pode ter várias ordens de serviço ao longo do tempo**
- Uma **ordem de serviço pode ter vários técnicos associados**
- Uma **ordem de serviço pode conter múltiplos serviços realizados**
- **Pagamentos podem ser parciais ou completos**