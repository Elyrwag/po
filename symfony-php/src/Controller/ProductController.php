<?php

namespace App\Controller;

use App\Entity\Product;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use App\Repository\ProductRepository;
use Doctrine\ORM\EntityManagerInterface;

final class ProductController extends AbstractController
{
    #[Route('/product', name: 'product_show_all', methods: ['GET'])]
    public function show_all(ProductRepository $productRepository): Response
    {
        $products = $productRepository->findAll();
        return $this->render('product/show_all.html.twig', ['products' => $products]);
    }

    #[Route('/product/{id}', name: 'product_show', methods: ['GET'])]
    public function show(ProductRepository $productRepository, int $id): Response
    {
        $product = $productRepository->find($id);
        if (!$product) { return new Response('No product found for id '.$id, 400); }

        return $this->render('product/show.html.twig', ['product' => $product]);
    }

    #[Route('/product', name: 'product_create', methods: ['POST'])]
    public function create(EntityManagerInterface $entityManager, Request $request): Response
    {
        if (!$request->getSession()->get('username')) { return new Response('Must login', 403); }

        $contentType = $request->headers->get('Content-Type');
        if (str_contains($contentType, 'application/json')) $data = json_decode($request->getContent(), true); // JSON
        else $data = $request->request->all(); // Form

        if (!isset($data['name']) || !isset($data['price']) || !isset($data['categoryID'])) {
            return new Response('Invalid data', 400);
        }

        $product = new Product();
        $product->setName($data['name']);
        $product->setPrice($data['price']);
        $product->setCategoryID($data['categoryID']);

        $entityManager->persist($product);
        $entityManager->flush();

        return $this->redirectToRoute('panel');
    }

    #[Route('/product/{id}', name: 'product_edit', methods: ['PUT'])]
    public function update(EntityManagerInterface $entityManager, ProductRepository $productRepository, int $id, Request $request): Response
    {
        if (!$request->getSession()->get('username')) { return new Response('Must login', 403); }

        $product = $productRepository->find($id);
        if (!$product) { return new Response('No product found for id '.$id, 400); }

        $contentType = $request->headers->get('Content-Type');
        if (str_contains($contentType, 'application/json')) $data = json_decode($request->getContent(), true); // JSON
        else $data = $request->request->all(); // Form

        if (isset($data['name'])) { $product->setName($data['name']); }
        if (isset($data['price'])) { $product->setPrice($data['price']); }
        if (isset($data['categoryID'])) { $product->setCategoryID($data['categoryID']); }
        $entityManager->flush();

        return $this->redirectToRoute('panel');
    }

    #[Route('/product/edit/{id}', name: 'product_edit_form', methods: ['GET'])]
    public function edit_form(Request $request, ProductRepository $productRepository, int $id): Response
    {
        if (!$request->getSession()->get('username')) { return $this->redirectToRoute('login'); }

        $product = $productRepository->find($id);
        if (!$product) { return new Response('No product found for id '.$id, 400); }

        return $this->render('product/edit.html.twig', ['product' => $product]);
    }

    #[Route('/product/{id}', name: 'product_delete', methods: ['DELETE'])]
    public function delete(EntityManagerInterface $entityManager, ProductRepository $productRepository, int $id, Request $request): Response
    {
        if (!$request->getSession()->get('username')) { return new Response('Must login', 403); }

        $product = $productRepository->find($id);
        if (!$product) { return new Response('No product found for id '.$id, 400); }

        $entityManager->remove($product);
        $entityManager->flush();

        return $this->redirectToRoute('panel');
    }
}
