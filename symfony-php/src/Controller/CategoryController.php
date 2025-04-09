<?php

namespace App\Controller;

use App\Entity\Category;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use App\Repository\CategoryRepository;
use Doctrine\ORM\EntityManagerInterface;

final class CategoryController extends AbstractController
{
    #[Route('/category', name: 'category_show_all', methods: ['GET'])]
    public function show_all(CategoryRepository $categoryRepository): Response
    {
        $categories = $categoryRepository->findAll();
        return $this->render('category/show_all.html.twig', ['categories' => $categories]);
    }

    #[Route('/category/{id}', name: 'category_show', methods: ['GET'])]
    public function show(CategoryRepository $categoryRepository, int $id): Response
    {
        $category = $categoryRepository->find($id);
        if (!$category) { return new Response('No category found for id '.$id, 400); }

        return $this->render('category/show.html.twig', ['category' => $category]);
    }

    #[Route('/category', name: 'category_create', methods: ['POST'])]
    public function create(EntityManagerInterface $entityManager, Request $request): Response
    {
        if (!$request->getSession()->get('username')) { return new Response('Must login', 403); }

        $contentType = $request->headers->get('Content-Type');
        if (str_contains($contentType, 'application/json')) $data = json_decode($request->getContent(), true); // JSON
        else $data = $request->request->all(); // Form

        if (!isset($data['name'])) {
            return new Response('Invalid data', 400);
        }

        $category = new Category();
        $category->setName($data['name']);

        $entityManager->persist($category);
        $entityManager->flush();

        return $this->redirectToRoute('panel');
    }

    #[Route('/category/{id}', name: 'category_edit', methods: ['PUT'])]
    public function update(EntityManagerInterface $entityManager, CategoryRepository $categoryRepository, int $id, Request $request): Response
    {
        if (!$request->getSession()->get('username')) { return new Response('Must login', 403); }

        $category = $categoryRepository->find($id);
        if (!$category) { return new Response('No category found for id '.$id, 400); }

        $contentType = $request->headers->get('Content-Type');
        if (str_contains($contentType, 'application/json')) $data = json_decode($request->getContent(), true); // JSON
        else $data = $request->request->all(); // Form

        if (isset($data['name'])) { $category->setName($data['name']); }
        $entityManager->flush();

        return $this->redirectToRoute('panel');
    }

    #[Route('/category/edit/{id}', name: 'category_edit_form', methods: ['GET'])]
    public function edit_form(Request $request, CategoryRepository $categoryRepository, int $id): Response
    {
        if (!$request->getSession()->get('username')) { return $this->redirectToRoute('login'); }

        $category = $categoryRepository->find($id);
        if (!$category) { return new Response('No category found for id '.$id, 400); }

        return $this->render('category/edit.html.twig', ['category' => $category]);
    }

    #[Route('/category/{id}', name: 'category_delete', methods: ['DELETE'])]
    public function delete(EntityManagerInterface $entityManager, CategoryRepository $categoryRepository, int $id, Request $request): Response
    {
        if (!$request->getSession()->get('username')) { return new Response('Must login', 403); }

        $category = $categoryRepository->find($id);
        if (!$category) { return new Response('No category found for id '.$id, 400); }

        $entityManager->remove($category);
        $entityManager->flush();

        return $this->redirectToRoute('panel');
    }
}
